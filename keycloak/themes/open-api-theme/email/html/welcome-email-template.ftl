<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Welcome | EcoCash Developer Portal</title>
</head>
<body style="margin:0;background:#F9FAFB;color:#1F2937;font-family:Arial,sans-serif;line-height:1.6;padding:32px 16px;">
<table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="border-collapse:collapse;">
    <tr>
        <td align="center">
            <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px;border-collapse:collapse;background:#FFFFFF;border:1px solid #E5E7EB;border-radius:8px;overflow:hidden;">

                <!-- Header -->
                <tr>
                    <td style="padding:28px 32px;background:#0052A5;">
                        <table role="presentation" cellpadding="0" cellspacing="0" style="border-collapse:collapse;">
                            <tr>
                                <td style="padding-left:0;">
                                    <div style="font-size:16px;font-weight:700;color:#FFFFFF;">EcoCash Developer Portal</div>
                                    <div style="font-size:11px;font-weight:600;letter-spacing:0.08em;color:#E30613;text-transform:uppercase;margin-top:2px;">Developer Sandbox</div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>

                <!-- Body -->
                <tr>
                    <td style="background:#FFFFFF;color:#1F2937;padding:32px;">
                        <h1 style="margin:0 0 8px;font-size:20px;line-height:1.3;color:#1F2937;font-weight:700;">Your account is ready</h1>
                        <p style="margin:0 0 20px;color:#6B7280;font-size:14px;">Hello <strong style="color:#1F2937;">${(user.firstName!'Developer')}</strong>, your EcoCash Developer Portal account has been created. Use the credentials below to sign in.</p>

                        <!-- Credentials table -->
                        <table role="presentation" cellpadding="0" cellspacing="0" width="100%" style="border-collapse:collapse;background:#F9FAFB;border:1px solid #E5E7EB;border-radius:8px;margin:0 0 24px;">
                            <tr>
                                <td style="padding:12px 16px;border-bottom:1px solid #E5E7EB;color:#6B7280;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.06em;width:120px;">Username</td>
                                <td style="padding:12px 16px;border-bottom:1px solid #E5E7EB;color:#1F2937;font-family:Monaco,Consolas,monospace;font-size:14px;font-weight:600;word-break:break-word;">${username!'your username'}</td>
                            </tr>
                            <tr>
                                <td style="padding:12px 16px;color:#6B7280;font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.06em;width:120px;">Password</td>
                                <td style="padding:12px 16px;color:#1F2937;font-family:Monaco,Consolas,monospace;font-size:14px;font-weight:600;word-break:break-word;">${password!'your temporary password'}</td>
                            </tr>
                        </table>

                        <p style="margin:0 0 20px;">
                            <a href="${loginUrl!'#'}" style="display:inline-block;background:#E30613;color:#FFFFFF;text-decoration:none;font-weight:600;border-radius:8px;padding:11px 22px;font-size:14px;">Sign in to Developer Portal</a>
                        </p>

                        <p style="margin:0;background:#FEF2F2;border-left:3px solid #E30613;border-radius:0 6px 6px 0;color:#B91C1C;padding:12px 14px;font-size:13px;">Do not forward this email. EcoCash will never ask you to share your password outside the official login page.</p>
                    </td>
                </tr>

                <!-- Footer -->
                <tr>
                    <td style="padding:20px 32px;color:#9CA3AF;font-size:12px;background:#F9FAFB;border-top:1px solid #E5E7EB;">
                        <p style="margin:0;">This message was sent by EcoCash Developer Portal. If you were not expecting this account, contact <a href="mailto:developer-support@ecocash.co.zw" style="color:#0052A5;text-decoration:none;font-weight:600;">developer-support@ecocash.co.zw</a>.</p>
                    </td>
                </tr>

            </table>
        </td>
    </tr>
</table>
</body>
</html>