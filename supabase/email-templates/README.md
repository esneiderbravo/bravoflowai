# BravoFlow AI — Email Templates

Supabase Auth email templates for BravoFlow AI.  
All templates use **inline CSS** for broad email-client compatibility.

---

## Templates

| File           | Supabase Template Slot | Trigger              |
|----------------|------------------------|----------------------|
| `welcome.html` | Confirm signup         | User registers       |
| `welcome.txt`  | Plain-text fallback    | Same trigger         |

---

## How to Apply in Supabase

1. Open your Supabase project dashboard.
2. Navigate to **Authentication → Email Templates**.
3. Select **Confirm signup**.
4. Paste the contents of `welcome.html` into the **HTML Body** field.
5. Paste the contents of `welcome.txt` into the **Plain Text Body** field (if supported).
6. Set the **Subject** to:

   ```
   Welcome to BravoFlow AI 🚀 Take control of your financial flow
   ```

7. Click **Save**.

---

## Placeholders to Replace Before Saving

| Placeholder              | Replace with                                              |
|--------------------------|-----------------------------------------------------------|
| `{{ .ConfirmationURL }}` | **Leave as-is** — Supabase injects the magic link at send time |
| `{{ .Email }}`           | **Leave as-is** — Supabase injects the recipient email   |
| `[APP_URL]`              | Your production URL, e.g. `https://bravoflowai.com`      |
| `[SUPPORT_EMAIL]`        | Your support address, e.g. `support@bravoflowai.com`     |
| `[LOGO_URL]`             | Absolute URL to hosted logo asset (uncomment `<img>` tag)|

---

## Supabase Template Variables Reference

Supabase uses **Go template syntax** inside email templates:

| Variable               | Description                        |
|------------------------|------------------------------------|
| `{{ .ConfirmationURL }}`| Full magic-link confirmation URL  |
| `{{ .Email }}`          | Recipient's email address         |
| `{{ .Token }}`          | Raw OTP token (if needed)         |
| `{{ .TokenHash }}`      | Hashed token (if needed)          |
| `{{ .SiteURL }}`        | Your Supabase Site URL             |

Full reference: https://supabase.com/docs/guides/auth/auth-email-templates

---

## Design Tokens Used

| Token           | Value     | Usage                     |
|-----------------|-----------|---------------------------|
| backgroundDark  | `#0B132B` | Page/outer background     |
| surfaceDark     | `#131D35` | Card background           |
| cardDark        | `#1A2540` | Feature icon background   |
| primaryBlue     | `#3A86FF` | CTA gradient start, links |
| violetAI        | `#7B61FF` | CTA gradient end, labels  |
| accentCyan      | `#00D4FF` | Header gradient end       |
| textPrimary     | `#FFFFFF` | Headings                  |
| textSecondary   | `#9CA3AF` | Body copy                 |
| textDisabled    | `#4B5563` | Footer / subtext          |

