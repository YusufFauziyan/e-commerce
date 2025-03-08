// models/userModel.ts
import db from "../config"; // Impor konfigurasi DB Anda
import { RowDataPacket, ResultSetHeader } from "mysql2/promise";
import { v4 as uuidv4 } from "uuid";
import { hashPassword } from "../utils/passwordUtils";
import { getOrderModel } from "./orderModel";
import { formatToTimestamp } from "../utils/formatTime";
import axios from "axios";

interface Payment extends RowDataPacket {
  id: string;
  order_id: string;
  transaction_id: number;
  payment_type: number;
  gross_amount: number;
  transaction_time: string;
  settlement_time: string;
  expiry_time: string;
}

// get all payment
export const getAllPaymentModel = async (
  userId: string,
  role: string
): Promise<Payment[]> => {
  let query = "";
  if (role === "admin") {
    query = "SELECT * FROM Payment";
  } else {
    query =
      "SELECT p.* FROM Payment p JOIN `Order` o ON p.order_id = o.order_id WHERE o.user_id = ?;";
  }
  const [rows] = await db.query<Payment[]>(query, [userId]);
  const payment = rows.map(async ({ payment_id, order_id, ...row }) => {
    const order = await getOrderModel(order_id);
    return {
      ...row,
      id: payment_id,
      order,
    };
  });

  return payment as unknown as Payment[];
};

// get payment by id
export const getPaymentModel = async (id: string): Promise<Payment | null> => {
  const query = "SELECT * FROM Payment WHERE payment_id = ?";
  const [rows] = await db.query<Payment[]>(query, [id]);

  if (rows.length === 0) return null;

  const { payment_id, ...payment } = rows[0];

  return { ...payment, id: payment_id };
};

// post payment
export const createPaymentModel = async (
  payment: Payment
): Promise<Payment> => {
  const { order_id } = payment;

  const paymentId = uuidv4();
  const query =
    "INSERT INTO Payment (payment_id, order_id, transaction_id, payment_type, gross_amount, transaction_time, settlement_time, expiry_time, transaction_status, payment_link) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

  await db.query<ResultSetHeader>(query, [
    paymentId,
    order_id,
    payment.transaction_id,
    payment.payment_type,
    payment.gross_amount,
    payment?.transaction_time
      ? formatToTimestamp(payment.transaction_time)
      : null,
    payment?.settlement_time
      ? formatToTimestamp(payment.settlement_time)
      : null,
    payment?.expiry_time ? formatToTimestamp(payment.expiry_time) : null,
    payment.transaction_status,
    payment?.payment_link,
  ]);

  // Fetch the newly created payment from the database
  const [rows] = await db.query<Payment[]>(
    "SELECT * FROM Payment WHERE payment_id = ?",
    [paymentId]
  );

  const { payment_id, ...row } = rows[0];
  const order = await getOrderModel(order_id);

  return { ...row, id: payment_id, order };
};

// put payment
export const updatePaymentModel = async (
  id: string,
  payment: Payment
): Promise<Payment | null> => {
  // Fetch the existing payment
  const [rows] = await db.query<Payment[]>(
    "SELECT * FROM Payment WHERE payment_id = ?",
    [id]
  );

  if (rows.length === 0) return null;

  const existingPayment = rows[0];

  // Update the payment
  const query =
    "UPDATE Payment SET transaction_id = ?, payment_type = ?, gross_amount = ?, transaction_time = ?, settlement_time = ?, expiry_time = ?, transaction_status = ? WHERE payment_id = ?";

  await db.query<ResultSetHeader>(query, [
    payment.transaction_id ?? existingPayment.transaction_id,
    payment.payment_type ?? existingPayment.payment_type,
    payment.gross_amount ?? existingPayment.gross_amount,
    payment.transaction_time
      ? formatToTimestamp(payment.transaction_time)
      : existingPayment.transaction_time,
    payment.settlement_time
      ? formatToTimestamp(payment.settlement_time)
      : existingPayment.settlement_time,
    payment.expiry_time
      ? formatToTimestamp(payment.expiry_time)
      : existingPayment.expiry_time,
    payment.transaction_status ?? existingPayment.transaction_status,
    id,
  ]);

  // Fetch and return the updated payment
  const [updatedRows] = await db.query<Payment[]>(
    "SELECT * FROM Payment WHERE payment_id = ?",
    [id]
  );

  const { payment_id, ...row } = updatedRows[0];
  const order = await getOrderModel(row.order_id);

  return { ...row, id: payment_id, order };
};

// delete payment
export const deletePaymentModel = async (id: string): Promise<boolean> => {
  const query = "DELETE FROM Payment WHERE payment_id = ?";
  const [result] = await db.query<ResultSetHeader>(query, [id]);
  return result.affectedRows > 0;
};

// midtrans
const MIDTRANS_URL = process.env.MIDTRANS_API_URL;
const SERVER_KEY = process.env.MIDTRANS_SERVER_KEY;

export const createPaymentLink = async (
  body: Record<string, any>
): Promise<string | null> => {
  if (!SERVER_KEY) {
    console.error("Error: MIDTRANS_SERVER_KEY is not set");
    return null;
  }

  const token = Buffer.from(`${SERVER_KEY}:`).toString("base64");

  try {
    const { data } = await axios.post(
      `${MIDTRANS_URL}/v1/payment-links`,
      { ...body, usage_limit: 1 },
      {
        headers: {
          Authorization: `Basic ${token}`,
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      }
    );

    return data?.payment_url || null;
  } catch (error: any) {
    if (error.response) {
      console.error("Midtrans API Error:", error.response.data);
    } else if (error.request) {
      console.error("No response from Midtrans API:", error.request);
    } else {
      console.error("Error creating payment link:", error.message);
    }
    return null;
  }
};

export const getPaymentLink = async (
  order_id: string
): Promise<string | null> => {
  const token = Buffer.from(`${SERVER_KEY}:`).toString("base64");

  try {
    const { data } = await axios.get(
      `${MIDTRANS_URL}/v1/payment-links/${order_id}`,
      {
        headers: {
          Authorization: `Basic ${token}`,
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      }
    );

    return data?.payment_link_url || null;
  } catch (error) {
    console.error("Error fetching payment link:", error);
    return null;
  }
};
