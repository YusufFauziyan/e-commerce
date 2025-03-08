// controllers/userController.ts
import { Request, Response } from "express";
import {
  createPaymentModel,
  getPaymentModel,
  getAllPaymentModel,
  updatePaymentModel,
  getPaymentLink,
  createPaymentLink,
} from "../models/paymentModel";
import { getUserByIdModel } from "../models/userModel";
import coreApi from "../config/midtransConfig";
import { getOrderModel, updateOrderModel } from "../models/orderModel";
import { getProductModel, updateProductModel } from "../models/productModel";

// Fetch all Payment or the logged-in Payment's data based on their role
export const getAllPayment = async (
  req: Request,
  res: Response
): Promise<void> => {
  const loggedInUser = (req as any).user;

  if (!loggedInUser) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }

  try {
    const payment = await getAllPaymentModel(
      loggedInUser.id,
      loggedInUser.role
    );

    res.status(200).json(payment);
  } catch (error) {
    console.error("Error retrieving payment:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// Payment by id
export const getPayment = async (req: Request, res: Response) => {
  const id = req.params.id; // Mengambil id dari parameter URL
  try {
    const payment = await getPaymentModel(id);
    if (payment) {
      res.status(200).json(payment);
    } else {
      res.status(404).json({ message: "Payment not found" });
    }
  } catch (error) {
    console.error("Error retrieving payment:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// create Payment
export const createPayment = async (req: Request, res: Response) => {
  const loggedInUser = (req as any).user;
  const { order_id } = req.body;

  if (!loggedInUser) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }

  if (!order_id) {
    res.status(400).json({ message: "order_id is required" });
    return;
  }

  try {
    // detail user
    const user = await getUserByIdModel(loggedInUser.id);
    const order = await getOrderModel(order_id);

    if (!order) {
      res.status(404).json({ message: "Order not found" });
      return;
    }

    if (!user) {
      res.status(404).json({ message: "User not found" });
      return;
    }

    const item_details = order.orders.map((orderItem: any) => ({
      id: orderItem.id,
      price: Number(orderItem.product.final_price),
      quantity: orderItem.quantity,
      name: orderItem.product.name.slice(0, 30),
      category: orderItem.product.categories.join(","),
    }));

    const totalAmount = item_details.reduce(
      (acc: number, item: any) => acc + item.price * item.quantity,
      0
    );

    const parameters = {
      transaction_details: {
        order_id: order_id,
        gross_amount: totalAmount,
      },
      credit_card: { secure: true },
      customer_details: {
        email: user.email,
        phone: user.phone_number,
        first_name: user.username,
      },
      item_details,
    };

    // post to midtrans
    const transactionToken = await coreApi.createTransactionToken(parameters);
    await createPaymentLink(parameters);

    res.status(201).json({
      message: "Payment created successfully",
      transactionToken,
    });
  } catch (error) {
    console.error("Error retrieving payment:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// payment noitifaction
export const paymentNotification = async (req: Request, res: Response) => {
  const { order_id, status_code } = req.body;

  try {
    // detail order
    const splitOrderid = order_id.split("-");
    const transformOrderId =
      splitOrderid.length > 5 ? splitOrderid.slice(0, -1).join("-") : order_id;

    const exitingOrder = await getOrderModel(transformOrderId);

    if (!exitingOrder) {
      res.status(404).json({ message: "Order not found" });
      return;
    }

    const productsOrdered = exitingOrder.orders;

    if (status_code === "201" || status_code === "200") {
      // payment midtrans created (201)
      if (status_code === "201") {
        // get transaction status
        const redirect_url = await getPaymentLink(order_id);

        console.log("Redirect URL:", redirect_url);

        // add payment to database
        const payment = await createPaymentModel({
          ...req.body,
          payment_link: redirect_url,
        });

        // update order transaction_id
        const payloadOrder = {
          payment_id: payment.id,
        } as any;

        await updateOrderModel(order_id, payloadOrder);
      }

      // payment success (200)
      if (status_code === "200") {
        // update payment
        await updatePaymentModel(exitingOrder.payment_id, req.body);

        // decrese stock and increase sold
        for (const { product, quantity } of productsOrdered) {
          const productId = product.id;
          const stock = Number(product.stock_quantity);
          const sold = Number(product.sold_quantity);

          const totalStock = stock - quantity;
          const totalSold = sold + quantity;

          await updateProductModel(productId, {
            stock_quantity: totalStock,
            sold_quantity: totalSold,
          });
        }

        console.log("Stock and sold quantity updated");
      }

      res
        .status(200)
        .json({ message: "Payment notification received, Thankyou 🫶" });

      return;
    }

    res
      .status(400)
      .json({ message: "Payment notification failed", data: req.body });
  } catch (error) {
    console.error("Error updating payment:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
