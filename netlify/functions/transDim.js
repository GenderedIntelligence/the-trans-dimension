require("dotenv").config();
const nodemailer = require("nodemailer");
const transDimConfig = require("../transDimConfig");

// Function wrapper for sending email that returns a promise
function sendEmail(mailOptions) {
   console.log(mailOptions);
   // Create the transporter for Nodemailer to post to the SMTP server
   const transporter = nodemailer.createTransport({
      host: transDimConfig.smtp.host,
      port: transDimConfig.smtp.port,
      secure: transDimConfig.smtp.secure,
      requireTLS: transDimConfig.smtp.require_tls,

      auth: {
         user: transDimConfig.smtp.auth_user,
         pass: transDimConfig.smtp.auth_pass
      }
   });
   return transporter.sendMail(mailOptions);
}

exports.handler = async function (event, context) {
   // Handle responses to OPTIONS preflight requests
   if (event.httpMethod === "OPTIONS") {
      console.log(event);
      return {
         statusCode: 200,
         headers: {
            "Access-Control-Allow-Origin": transDimConfig.allow_domain,
            "Access-Control-Allow-Methods": "POST",
            "Access-Control-Allow-Headers":
               "Origin, X-Requested-With, Content-Type, Accept"
         }
      };
   }
   // Handle responses to POST requests
   else {
      console.log(event);

      // Decode the JSON from the request body string
      const bodyParsed = JSON.parse(event.body);
      const { formData } = bodyParsed;

      const enquirerName = formData.name;
      const enquirerEmail = formData.email;
      const enquirerMessage = formData.message;

      const fields = [
         { label: "Name", value: enquirerName },
         { label: "Email", value: enquirerEmail },
         { label: "Phone number", value: formData.phone },
         { label: "Job title", value: formData.job },
         { label: "Organisation", value: formData.organisation },
         { label: "Postcode", value: formData.postcode },
         {
            label: "I'd like a ring back",
            value: formData.ringBack == true ? "Yes" : "No"
         },
         {
            label: "I'd like more information",
            value: formData.moreInfo == true ? "Yes" : "No"
         }
      ];

      // Deconstruct the recipients and styling from the config for ease of use
      const emailRecipients = transDimConfig.email_recipients;
      const emailStyling = transDimConfig.email_styling;

      // Construct the email from the request body
      const email = {
         priority: "normal",
         from: {
            name: enquirerName,
            address: process.env.EMAIL_FROM // the EnquiryWitch email to send from
         },
         replyTo: {
            name: enquirerName, // 'reply to' name details
            address: enquirerEmail // 'reply to' email address
         },
         to: emailRecipients.info,
         subject: `Request to join The Trans Dimension from ${enquirerName}`,
         text:
            `${emailStyling.header_text || "Web Enquiry"}\n\n-----------\n\n` +
            fields
               .map(
                  (field) =>
                     `${field.label}: ${
                        field.value == "" ? "Not answered" : field.value
                     }`
               )
               .join("\n") +
            "\nMessage\n\n" +
            enquirerEmail +
            "\n\n-----------\n\nReply to this email to reply to the sender.\n\n-----------", // plain text email
         html:
            '<html>\n<body>\n<div id="email-container" style="background-color: #F6F6F6; height: 100%; width: 100%; display: block; padding: 25px 0;">\n<div id="message-container" style="display: block; background-color: white; width: 100%; max-width: 700px; margin: auto;">\n<div id="message-header" class="banner" style="background-color: #' +
            (emailStyling.header_background_colour || "000000") +
            "; padding: 10px 10px 10px 10px; color: #" +
            (emailStyling.header_text_color || "ffffff") +
            '; font-family: Courier, monotype; font-size: 20px; text-align: center;">\n' +
            (emailStyling.alternate_header_image ||
            emailStyling.netlify_header_image
               ? '<div id="message-header-logo">\n<img src="cid:logo" style="height: 50px; display: block;" height="50" />\n</div>\n'
               : "") +
            '<div id="message-header-text">\n' +
            (emailStyling.header_text || "Web Enquiry") +
            '\n</div>\n</div>\n<div id="message-main" style="padding: 25px 10px 25px 10px; width: 100%; margin: auto; max-width: 600px; display: block; color: #' +
            (emailStyling.body_text_color || "000000") +
            ';">\n' +
            fields
               .map(
                  (field) =>
                     `<p style="font-family: Verdana, sans-serif; font-size: 15px;">\n<strong>\n${
                        field.label
                     }: </strong>${
                        field.value == ""
                           ? "<em>Not answered</em>"
                           : field.value
                     }\n</p>\n`
               )
               .join("") +
            '<p style="font-family: Verdana, sans-serif; font-size: 15px;">\n<strong>Message:</strong>\n</p>\n<p style="font-family: Verdana, sans-serif; font-size: 15px;">\n' +
            enquirerMessage +
            '\n</p>\n</div>\n<div id="message-footer" class="banner" style="display: block; background-color: #' +
            (emailStyling.footer_background_colour || "000000") +
            "; padding: 10px 10px 10px 10px; color: #" +
            (emailStyling.footer_text_color || "ffffff") +
            '; font-family: Courier, monotype, sans-serif; font-size: 12px;">\n<p style="text-align: center">Reply to this email to reply to the sender.</p>\n</div>\n</div>\n</div>\n</body>\n</html>' // HTML (styled and formatted) email
      };

      try {
         console.log("try");
         const res = await sendEmail(email);
         console.log(res);
         return {
            statusCode: 200,
            headers: {
               /* Required for CORS support to work */
               "Access-Control-Allow-Origin": transDimConfig.allow_domain,
               // /* Required for cookies, authorization headers with HTTPS */
               "Access-Control-Allow-Credentials": true,
               "Access-Control-Allow-Headers":
                  "Origin, X-Requested-With, Content-Type, Accept",

               "Content-Type": "text/plain"
            }
         };
      } catch (err) {
         console.log("catch");
         console.log(err);
         return {
            statusCode: err.responseCode,
            headers: {
               /* Required for CORS support to work */
               "Access-Control-Allow-Origin": transDimConfig.allow_domain,
               // /* Required for cookies, authorization headers with HTTPS */
               "Access-Control-Allow-Credentials": true,
               "Access-Control-Allow-Headers":
                  "Origin, X-Requested-With, Content-Type, Accept",
               "Content-Type": "text/plain"
            },
            body: err.response
         };
      }
   }
};
