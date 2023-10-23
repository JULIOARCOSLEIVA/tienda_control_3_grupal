// Importando las funciones y variables necesarias
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Función de ejemplo
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});


const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/*crear producto */
exports.createProduct = functions.https.onRequest(async (req, res) => {
    if (req.method !== "POST") {
        return res.status(400).send({ message: "Sólo se admite el método POST." });
    }

    const product = req.body;
    try {
        const docRef = await admin.firestore().collection("products").add(product);
        return res.status(201).send({ id: docRef.id });
    } catch (error) {
        return res.status(500).send(error);
    }
});

/*actualizar producto */
exports.updateProduct = functions.https.onRequest(async (req, res) => {
    if (req.method !== "PUT") {
        return res.status(400).send({ message: "Sólo se admite el método PUT." });
    }

    const productId = req.query.id;
    const productData = req.body;

    try {
        const productRef = admin.firestore().collection("products").doc(productId);
        await productRef.update(productData);
        return res.status(200).send({ message: "Producto actualizado con éxito." });
    } catch (error) {
        return res.status(500).send(error);
    }
});

/* eliminar producto */

exports.deleteProduct = functions.https.onRequest(async (req, res) => {
    if (req.method !== "DELETE") {
        return res.status(400).send({ message: "Sólo se admite el método DELETE." });
    }

    const productId = req.query.id;

    try {
        const productRef = admin.firestore().collection("products").doc(productId);
        await productRef.delete();
        return res.status(200).send({ message: "Producto eliminado con éxito." });
    } catch (error) {
        return res.status(500).send(error);
    }
});
