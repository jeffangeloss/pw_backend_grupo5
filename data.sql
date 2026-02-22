INSERT INTO "user" (
  id,
  full_name,
  email,
  password_hash,
  role,
  email_verified,
  is_active
)
VALUES
(
  '3f695099-1016-4b59-a027-f7e28da0f265',
  'Usuario Demo',
  'ejemplo@user.com',
  '$argon2id$v=19$m=65536,t=3,p=4$lcOx2xcOv/reQXAF3VXilw$Cb+DdfU31Jip2x5LFjYc1lPzrcxjxtD1UNcKAMVUrf0',
  'user'::user_role,
  true,
  true
),
(
  '7f9db8dc-b088-4731-9dd0-2a70e721c822',
  'Admin Demo',
  'ejemplo@admin.com',
  '$argon2id$v=19$m=65536,t=3,p=4$7MsLqdosXJphqkqGlw7HQA$z1BHKiljeIEQa5Jh3mTe+RIuxKtWmHd7jcms7m4CZPQ',
  'admin'::user_role,
  true,
  true
)
ON CONFLICT (email) DO UPDATE
SET
  full_name = EXCLUDED.full_name,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  email_verified = EXCLUDED.email_verified,
  is_active = EXCLUDED.is_active;
