
const express = require('express');
const cors = require('cors');
const nodemailer = require('nodemailer');

const app = express();
app.use(cors());
app.use(express.json());

const MANAGER_EMAIL = process.env.MANAGER_EMAIL || 'manager@example.com';
const SMTP_HOST = process.env.SMTP_HOST || '';
const SMTP_PORT = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT) : 587;
const SMTP_USER = process.env.SMTP_USER || '';
const SMTP_PASS = process.env.SMTP_PASS || '';

let transporter = nodemailer.createTransport({
  host: SMTP_HOST,
  port: SMTP_PORT,
  secure: SMTP_PORT === 465,
  auth: {
    user: SMTP_USER,
    pass: SMTP_PASS
  }
});

app.post('/send-order', async (req, res) => {
  const { name, email, amount, network, location, items } = req.body;
  try {
    const itemsHtml = (items || []).map(it => `<li>${it.name} x${it.qty} - ${it.price} FCFA</li>`).join('');
    const mailOptions = {
      from: SMTP_USER || 'odeca@example.com',
      to: MANAGER_EMAIL,
      subject: `Nouvelle commande ODECA - ${name} - ${amount} FCFA`,
      html: `
        <p>Nom: ${name}</p>
        <p>Email: ${email}</p>
        <p>Montant: ${amount} FCFA</p>
        <p>Réseau: ${network}</p>
        <p>Localisation: <a href="${location}">${location}</a></p>
        <p>Items:</p>
        <ul>${itemsHtml}</ul>
      `
    };
    await transporter.sendMail(mailOptions);
    res.json({ ok: true, message: 'Email envoyé' });
  } catch (err) {
    console.error('Erreur envoi mail:', err);
    res.status(500).json({ ok:false, error: err.message });
  }
});

app.get('/', (req,res)=> res.send('ODECA backend running'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, ()=> console.log('ODECA backend listening on', PORT));
