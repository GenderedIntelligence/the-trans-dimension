const transDimConfig = {
   // SMTP SETTINGS of server that will handle the actual sending of the emails
   smtp: {
      host: process.env.SMTP_HOST,
      port: process.env.SMTP_PORT,
      secure: process.env.SMTP_SECURE == "true",
      require_tls: process.env.SMTP_REQUIRE_TLS = "true",
      auth_user: process.env.SMTP_USERNAME,
      auth_pass: process.env.SMTP_PASSWORD
   },
   // ALLOWED DOMAIN is the domain the form is hosted on that will be sending the requests
   allow_domain: "*", // allows requests only from this domain - IMPORTANT! use '*' (wildcard) as the value for testing only
   // The root URL of your deployed function
   netlify_deploy_url: "https://fervent-colden-5f0cd2.netlify.app", // the base URL, without an ending / (forward slash)
   // EMAIL STYLING of the generated email
   email_styling: {
      header_text: "Request to join The Trans Dimension", // a title, keep as short as possible
      header_background_colour: "FF7AA7", // hex codes only, not including the #
      header_text_color: "040F39", // hex codes only, not including the #
      body_text_color: "040F39", // hex codes only, not including the #
      footer_background_colour: "53C3FF", // hex codes only, not including the #
      footer_text_color: "040F39", // hex codes only, not including the #
      netlify_header_image: "", // this has to be deployed to Netlify - if not in the root, add a path, e.g. "images/logo.jpeg" - without a starting / (forward slash)
      alternate_header_image: "" // if you have a publicly hosted image, the whole URL including http/https goes here, and will override a netlify_header_image if specified
   },
   // EMAIL RECIPIENTS is all possible destinations for your contact form to be directed to
   email_recipients: {
       // fill this in to correlate with your environment variables as described above
      info: process.env.EMAIL_INFO_TRANS_DIM,
      admin: process.env.EMAIL_ADMIN
   }
};

module.exports = transDimConfig;
