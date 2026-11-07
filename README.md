
# 90-Day Success Tracker

A personal productivity and progress tracking website.

## Features

- Email OTP and phone OTP authentication
- Private user accounts
- 30-day personal improvement plan
- 90-day daily checklist
- Progress dashboard and calendar
- IELTS preparation tracker
- LLM Cybersecurity project tracker
- Research paper tracker
- 13-week roadmap
- Daily routine checklist
- Weekly proof-of-work uploads
- Weekly progress reports
- JSON backup and restore
- Supabase cloud database and private storage

## Requirements

- A GitHub account
- A Supabase account
- A modern web browser

## 1. Create a Supabase project

Visit https://supabase.com/

Create a new project.

## 2. Set up the database

1. Open your Supabase project.
2. Open SQL Editor.
3. Create a new query.
4. Paste the contents of setup.sql.
5. Run the query.

## 3. Configure website credentials

Open Project Settings > API.

Copy:
- Project URL
- Anon / Publishable key

Open index.html.

Find:

    const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
    const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";

Replace the placeholders with your own values.

Never use the service_role secret key in browser code.

## 4. Configure authentication

In Supabase, open Authentication > Sign In / Providers.

Enable Email.

For email OTP, configure the email template to include the OTP token
using the Supabase-supported token template.

For phone OTP:
- Enable Phone authentication.
- Configure an SMS provider.
- Check the provider's pricing and message limits.

## 5. Publish with GitHub Pages

1. Create a GitHub repository.
2. Upload index.html, setup.sql and README.md.
3. Open repository Settings.
4. Select Pages.
5. Choose Deploy from a branch.
6. Select the main branch.
7. Select the root folder.
8. Save.

Wait for GitHub Pages to publish your site.

## 6. Test

- Register using email.
- Verify your OTP.
- Add a daily task.
- Save your personal plan.
- Upload a proof file.
- Log out and log in again.
- Check that your data is still there.

## Storage

The SQL creates a private bucket named weekly-proof.
The website currently limits each upload to 25 MB.

Supabase free-plan quotas apply.

## Security

- User data is protected by Row Level Security.
- Storage files are private.
- Users can only access their own records and files.
- The website uses the Supabase anon/publishable key.
- Never put a service_role key in index.html.
