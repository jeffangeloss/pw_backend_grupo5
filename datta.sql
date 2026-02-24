-- Demo seed data for local presentations and end-to-end validation.
-- Requires schema up to Alembic head (includes roles owner/auditor and admin_audit_log).
-- Passwords are stored as Argon2 hashes to avoid committing plaintext credentials.

BEGIN;

INSERT INTO "user" (
    id,
    full_name,
    email,
    password_hash,
    avatar_url,
    role,
    token_pass,
    token_pass_expires,
    token_verification,
    token_verification_expires,
    email_verified,
    is_active,
    created_at,
    updated_at
)
VALUES
(
    '10000000-0000-0000-0000-000000000001',
    'Owner Demo',
    'demo.owner@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-owner.png',
    'owner'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-10 09:00:00',
    '2026-02-24 09:00:00'
),
(
    '10000000-0000-0000-0000-000000000002',
    'Admin Demo',
    'demo.admin@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-admin.png',
    'admin'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-12-05 10:15:00',
    '2026-02-24 09:10:00'
),
(
    '10000000-0000-0000-0000-000000000003',
    'Auditor Demo',
    'demo.auditor@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-auditor.png',
    'auditor'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-01-03 08:45:00',
    '2026-02-24 09:20:00'
),
(
    '10000000-0000-0000-0000-000000000004',
    'Gaby User Demo',
    'demo.user1@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-user1.png',
    'user'::user_role,
    'seed-reset-token-demo-user1',
    '2026-12-31 23:59:59',
    NULL,
    NULL,
    true,
    true,
    '2026-01-15 14:20:00',
    '2026-02-24 09:30:00'
),
(
    '10000000-0000-0000-0000-000000000005',
    'Mariel User Demo',
    'demo.user2@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-user2.png',
    'user'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-02-02 12:00:00',
    '2026-02-24 09:40:00'
),
(
    '10000000-0000-0000-0000-000000000006',
    'Jeff User Demo',
    'demo.user3@finanzas.pe',
    '$argon2id$v=19$m=65536,t=3,p=4$/0LUfMpA/Aakb9Yftdnzkw$GPVSYG+VPpmzw0jZ5EmSY9rqc8TQvC8OSwFkKvarjYc',
    '/uploads/avatars/demo-user3.png',
    'user'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2026-02-14 16:30:00',
    '2026-02-24 09:50:00'
),
(
    '3f695099-1016-4b59-a027-f7e28da0f265',
    'Usuario Demo',
    'ejemplo@user.com',
    '$argon2id$v=19$m=65536,t=3,p=4$lcOx2xcOv/reQXAF3VXilw$Cb+DdfU31Jip2x5LFjYc1lPzrcxjxtD1UNcKAMVUrf0',
    NULL,
    'user'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-01 09:00:00',
    '2026-02-24 10:00:00'
),
(
    '7f9db8dc-b088-4731-9dd0-2a70e721c822',
    'Admin Demo',
    'ejemplo@admin.com',
    '$argon2id$v=19$m=65536,t=3,p=4$7MsLqdosXJphqkqGlw7HQA$z1BHKiljeIEQa5Jh3mTe+RIuxKtWmHd7jcms7m4CZPQ',
    NULL,
    'admin'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-01 09:10:00',
    '2026-02-24 10:10:00'
),
(
    '80b44d36-f154-4a08-8cb7-1eec0204cb59',
    'Owner Demo',
    'ejemplo@owner.com',
    '$argon2id$v=19$m=65536,t=3,p=4$7MsLqdosXJphqkqGlw7HQA$z1BHKiljeIEQa5Jh3mTe+RIuxKtWmHd7jcms7m4CZPQ',
    NULL,
    'owner'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-01 09:20:00',
    '2026-02-24 10:20:00'
),
(
    'a7e2e064-0358-4688-8a24-080e6d024920',
    'Auditor Demo',
    'ejemplo@auditor.com',
    '$argon2id$v=19$m=65536,t=3,p=4$7MsLqdosXJphqkqGlw7HQA$z1BHKiljeIEQa5Jh3mTe+RIuxKtWmHd7jcms7m4CZPQ',
    NULL,
    'auditor'::user_role,
    NULL,
    NULL,
    NULL,
    NULL,
    true,
    true,
    '2025-11-01 09:30:00',
    '2026-02-24 10:30:00'
)
ON CONFLICT (email) DO UPDATE
SET
    full_name = EXCLUDED.full_name,
    password_hash = EXCLUDED.password_hash,
    avatar_url = EXCLUDED.avatar_url,
    role = EXCLUDED.role,
    token_pass = EXCLUDED.token_pass,
    token_pass_expires = EXCLUDED.token_pass_expires,
    token_verification = EXCLUDED.token_verification,
    token_verification_expires = EXCLUDED.token_verification_expires,
    email_verified = EXCLUDED.email_verified,
    is_active = EXCLUDED.is_active,
    created_at = EXCLUDED.created_at,
    updated_at = EXCLUDED.updated_at;

INSERT INTO category (
    id,
    name,
    description,
    created_at
)
VALUES
(
    '20000000-0000-0000-0000-000000000001',
    'Alimentacion',
    'Comidas y supermercado',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000002',
    'Transporte',
    'Movilidad diaria y viajes',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000003',
    'Servicios',
    'Luz, agua, internet y telefonia',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000004',
    'Salud',
    'Medicinas, consultas y examenes',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000005',
    'Educacion',
    'Cursos, talleres y materiales',
    '2026-01-01 00:00:00'
),
(
    '20000000-0000-0000-0000-000000000006',
    'Entretenimiento',
    'Cine, salidas y ocio',
    '2026-01-01 00:00:00'
)
ON CONFLICT (name) DO UPDATE
SET
    description = EXCLUDED.description;

-- Expense seed: 2021-01 to 2025-12 (at least 1 per month per user).
-- Totals vary by user to support comparative charts and realistic trajectories.
--   demo.owner@finanzas.pe: 64 inserts
--   demo.admin@finanzas.pe: 68 inserts
--   demo.auditor@finanzas.pe: 72 inserts
--   demo.user1@finanzas.pe: 84 inserts
--   demo.user2@finanzas.pe: 78 inserts
--   demo.user3@finanzas.pe: 70 inserts
--   ejemplo@user.com: 90 inserts
--   ejemplo@admin.com: 66 inserts
--   ejemplo@owner.com: 74 inserts
--   ejemplo@auditor.com: 80 inserts

INSERT INTO expense (
    id,
    user_id,
    category_id,
    amount,
    expense_date,
    description,
    created_at,
    updated_at
)
VALUES
(
    '30000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    38.00,
    '2021-01-05 08:00:00',
    'Gasto mensual alimentacion 2021-01',
    '2021-01-05 08:00:00',
    '2021-01-05 08:00:00'
),
(
    '30000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    39.00,
    '2021-01-08 19:23:00',
    'Gasto adicional salud 2021-01',
    '2021-01-08 19:23:00',
    '2021-01-08 19:23:00'
),
(
    '30000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    45.37,
    '2021-02-06 08:07:00',
    'Gasto mensual transporte 2021-02',
    '2021-02-06 08:07:00',
    '2021-02-06 08:07:00'
),
(
    '30000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    52.74,
    '2021-03-07 08:14:00',
    'Gasto mensual servicios 2021-03',
    '2021-03-07 08:14:00',
    '2021-03-07 08:14:00'
),
(
    '30000000-0000-0000-0000-000000000005',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    59.00,
    '2021-04-08 08:21:00',
    'Gasto mensual salud 2021-04',
    '2021-04-08 08:21:00',
    '2021-04-08 08:21:00'
),
(
    '30000000-0000-0000-0000-000000000006',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    66.37,
    '2021-05-09 08:28:00',
    'Gasto mensual educacion 2021-05',
    '2021-05-09 08:28:00',
    '2021-05-09 08:28:00'
),
(
    '30000000-0000-0000-0000-000000000007',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    73.74,
    '2021-06-10 08:35:00',
    'Gasto mensual entretenimiento 2021-06',
    '2021-06-10 08:35:00',
    '2021-06-10 08:35:00'
),
(
    '30000000-0000-0000-0000-000000000008',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    80.00,
    '2021-07-11 08:42:00',
    'Gasto mensual alimentacion 2021-07',
    '2021-07-11 08:42:00',
    '2021-07-11 08:42:00'
),
(
    '30000000-0000-0000-0000-000000000009',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    87.37,
    '2021-08-12 08:49:00',
    'Gasto mensual transporte 2021-08',
    '2021-08-12 08:49:00',
    '2021-08-12 08:49:00'
),
(
    '30000000-0000-0000-0000-000000000010',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    94.74,
    '2021-09-13 08:56:00',
    'Gasto mensual servicios 2021-09',
    '2021-09-13 08:56:00',
    '2021-09-13 08:56:00'
),
(
    '30000000-0000-0000-0000-000000000011',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    101.00,
    '2021-10-14 08:03:00',
    'Gasto mensual salud 2021-10',
    '2021-10-14 08:03:00',
    '2021-10-14 08:03:00'
),
(
    '30000000-0000-0000-0000-000000000012',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    108.37,
    '2021-11-15 08:10:00',
    'Gasto mensual educacion 2021-11',
    '2021-11-15 08:10:00',
    '2021-11-15 08:10:00'
),
(
    '30000000-0000-0000-0000-000000000013',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    115.74,
    '2021-12-16 08:17:00',
    'Gasto mensual entretenimiento 2021-12',
    '2021-12-16 08:17:00',
    '2021-12-16 08:17:00'
),
(
    '30000000-0000-0000-0000-000000000014',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    94.00,
    '2021-12-19 19:40:00',
    'Gasto adicional servicios 2021-12',
    '2021-12-19 19:40:00',
    '2021-12-19 19:40:00'
),
(
    '30000000-0000-0000-0000-000000000015',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    122.00,
    '2022-01-17 08:24:00',
    'Gasto mensual alimentacion 2022-01',
    '2022-01-17 08:24:00',
    '2022-01-17 08:24:00'
),
(
    '30000000-0000-0000-0000-000000000016',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    129.37,
    '2022-02-18 08:31:00',
    'Gasto mensual transporte 2022-02',
    '2022-02-18 08:31:00',
    '2022-02-18 08:31:00'
),
(
    '30000000-0000-0000-0000-000000000017',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    136.74,
    '2022-03-19 08:38:00',
    'Gasto mensual servicios 2022-03',
    '2022-03-19 08:38:00',
    '2022-03-19 08:38:00'
),
(
    '30000000-0000-0000-0000-000000000018',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    143.00,
    '2022-04-20 08:45:00',
    'Gasto mensual salud 2022-04',
    '2022-04-20 08:45:00',
    '2022-04-20 08:45:00'
),
(
    '30000000-0000-0000-0000-000000000019',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    150.37,
    '2022-05-21 08:52:00',
    'Gasto mensual educacion 2022-05',
    '2022-05-21 08:52:00',
    '2022-05-21 08:52:00'
),
(
    '30000000-0000-0000-0000-000000000020',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    157.74,
    '2022-06-22 08:59:00',
    'Gasto mensual entretenimiento 2022-06',
    '2022-06-22 08:59:00',
    '2022-06-22 08:59:00'
),
(
    '30000000-0000-0000-0000-000000000021',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    164.00,
    '2022-07-23 08:06:00',
    'Gasto mensual alimentacion 2022-07',
    '2022-07-23 08:06:00',
    '2022-07-23 08:06:00'
),
(
    '30000000-0000-0000-0000-000000000022',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    171.37,
    '2022-08-24 08:13:00',
    'Gasto mensual transporte 2022-08',
    '2022-08-24 08:13:00',
    '2022-08-24 08:13:00'
),
(
    '30000000-0000-0000-0000-000000000023',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    178.74,
    '2022-09-05 08:20:00',
    'Gasto mensual servicios 2022-09',
    '2022-09-05 08:20:00',
    '2022-09-05 08:20:00'
),
(
    '30000000-0000-0000-0000-000000000024',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    185.00,
    '2022-10-06 08:27:00',
    'Gasto mensual salud 2022-10',
    '2022-10-06 08:27:00',
    '2022-10-06 08:27:00'
),
(
    '30000000-0000-0000-0000-000000000025',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    192.37,
    '2022-11-07 08:34:00',
    'Gasto mensual educacion 2022-11',
    '2022-11-07 08:34:00',
    '2022-11-07 08:34:00'
),
(
    '30000000-0000-0000-0000-000000000026',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    54.00,
    '2022-11-10 19:57:00',
    'Gasto adicional transporte 2022-11',
    '2022-11-10 19:57:00',
    '2022-11-10 19:57:00'
),
(
    '30000000-0000-0000-0000-000000000027',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    199.74,
    '2022-12-08 08:41:00',
    'Gasto mensual entretenimiento 2022-12',
    '2022-12-08 08:41:00',
    '2022-12-08 08:41:00'
),
(
    '30000000-0000-0000-0000-000000000028',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    206.00,
    '2023-01-09 08:48:00',
    'Gasto mensual alimentacion 2023-01',
    '2023-01-09 08:48:00',
    '2023-01-09 08:48:00'
),
(
    '30000000-0000-0000-0000-000000000029',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    213.37,
    '2023-02-10 08:55:00',
    'Gasto mensual transporte 2023-02',
    '2023-02-10 08:55:00',
    '2023-02-10 08:55:00'
),
(
    '30000000-0000-0000-0000-000000000030',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    220.74,
    '2023-03-11 08:02:00',
    'Gasto mensual servicios 2023-03',
    '2023-03-11 08:02:00',
    '2023-03-11 08:02:00'
),
(
    '30000000-0000-0000-0000-000000000031',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    227.00,
    '2023-04-12 08:09:00',
    'Gasto mensual salud 2023-04',
    '2023-04-12 08:09:00',
    '2023-04-12 08:09:00'
),
(
    '30000000-0000-0000-0000-000000000032',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    234.37,
    '2023-05-13 08:16:00',
    'Gasto mensual educacion 2023-05',
    '2023-05-13 08:16:00',
    '2023-05-13 08:16:00'
),
(
    '30000000-0000-0000-0000-000000000033',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    241.74,
    '2023-06-14 08:23:00',
    'Gasto mensual entretenimiento 2023-06',
    '2023-06-14 08:23:00',
    '2023-06-14 08:23:00'
),
(
    '30000000-0000-0000-0000-000000000034',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    28.00,
    '2023-07-15 08:30:00',
    'Gasto mensual alimentacion 2023-07',
    '2023-07-15 08:30:00',
    '2023-07-15 08:30:00'
),
(
    '30000000-0000-0000-0000-000000000035',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    35.37,
    '2023-08-16 08:37:00',
    'Gasto mensual transporte 2023-08',
    '2023-08-16 08:37:00',
    '2023-08-16 08:37:00'
),
(
    '30000000-0000-0000-0000-000000000036',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    42.74,
    '2023-09-17 08:44:00',
    'Gasto mensual servicios 2023-09',
    '2023-09-17 08:44:00',
    '2023-09-17 08:44:00'
),
(
    '30000000-0000-0000-0000-000000000037',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    49.00,
    '2023-10-18 08:51:00',
    'Gasto mensual salud 2023-10',
    '2023-10-18 08:51:00',
    '2023-10-18 08:51:00'
),
(
    '30000000-0000-0000-0000-000000000038',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    14.00,
    '2023-10-21 19:14:00',
    'Gasto adicional alimentacion 2023-10',
    '2023-10-21 19:14:00',
    '2023-10-21 19:14:00'
),
(
    '30000000-0000-0000-0000-000000000039',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    56.37,
    '2023-11-19 08:58:00',
    'Gasto mensual educacion 2023-11',
    '2023-11-19 08:58:00',
    '2023-11-19 08:58:00'
),
(
    '30000000-0000-0000-0000-000000000040',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    63.74,
    '2023-12-20 08:05:00',
    'Gasto mensual entretenimiento 2023-12',
    '2023-12-20 08:05:00',
    '2023-12-20 08:05:00'
),
(
    '30000000-0000-0000-0000-000000000041',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    70.00,
    '2024-01-21 08:12:00',
    'Gasto mensual alimentacion 2024-01',
    '2024-01-21 08:12:00',
    '2024-01-21 08:12:00'
),
(
    '30000000-0000-0000-0000-000000000042',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    77.37,
    '2024-02-22 08:19:00',
    'Gasto mensual transporte 2024-02',
    '2024-02-22 08:19:00',
    '2024-02-22 08:19:00'
),
(
    '30000000-0000-0000-0000-000000000043',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    84.74,
    '2024-03-23 08:26:00',
    'Gasto mensual servicios 2024-03',
    '2024-03-23 08:26:00',
    '2024-03-23 08:26:00'
),
(
    '30000000-0000-0000-0000-000000000044',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    91.00,
    '2024-04-24 08:33:00',
    'Gasto mensual salud 2024-04',
    '2024-04-24 08:33:00',
    '2024-04-24 08:33:00'
),
(
    '30000000-0000-0000-0000-000000000045',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    98.37,
    '2024-05-05 08:40:00',
    'Gasto mensual educacion 2024-05',
    '2024-05-05 08:40:00',
    '2024-05-05 08:40:00'
),
(
    '30000000-0000-0000-0000-000000000046',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    105.74,
    '2024-06-06 08:47:00',
    'Gasto mensual entretenimiento 2024-06',
    '2024-06-06 08:47:00',
    '2024-06-06 08:47:00'
),
(
    '30000000-0000-0000-0000-000000000047',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    112.00,
    '2024-07-07 08:54:00',
    'Gasto mensual alimentacion 2024-07',
    '2024-07-07 08:54:00',
    '2024-07-07 08:54:00'
),
(
    '30000000-0000-0000-0000-000000000048',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    119.37,
    '2024-08-08 08:01:00',
    'Gasto mensual transporte 2024-08',
    '2024-08-08 08:01:00',
    '2024-08-08 08:01:00'
),
(
    '30000000-0000-0000-0000-000000000049',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    126.74,
    '2024-09-09 08:08:00',
    'Gasto mensual servicios 2024-09',
    '2024-09-09 08:08:00',
    '2024-09-09 08:08:00'
),
(
    '30000000-0000-0000-0000-000000000050',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    133.00,
    '2024-10-10 08:15:00',
    'Gasto mensual salud 2024-10',
    '2024-10-10 08:15:00',
    '2024-10-10 08:15:00'
),
(
    '30000000-0000-0000-0000-000000000051',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    140.37,
    '2024-11-11 08:22:00',
    'Gasto mensual educacion 2024-11',
    '2024-11-11 08:22:00',
    '2024-11-11 08:22:00'
),
(
    '30000000-0000-0000-0000-000000000052',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    147.74,
    '2024-12-12 08:29:00',
    'Gasto mensual entretenimiento 2024-12',
    '2024-12-12 08:29:00',
    '2024-12-12 08:29:00'
),
(
    '30000000-0000-0000-0000-000000000053',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    154.00,
    '2025-01-13 08:36:00',
    'Gasto mensual alimentacion 2025-01',
    '2025-01-13 08:36:00',
    '2025-01-13 08:36:00'
),
(
    '30000000-0000-0000-0000-000000000054',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    161.37,
    '2025-02-14 08:43:00',
    'Gasto mensual transporte 2025-02',
    '2025-02-14 08:43:00',
    '2025-02-14 08:43:00'
),
(
    '30000000-0000-0000-0000-000000000055',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    168.74,
    '2025-03-15 08:50:00',
    'Gasto mensual servicios 2025-03',
    '2025-03-15 08:50:00',
    '2025-03-15 08:50:00'
),
(
    '30000000-0000-0000-0000-000000000056',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    175.00,
    '2025-04-16 08:57:00',
    'Gasto mensual salud 2025-04',
    '2025-04-16 08:57:00',
    '2025-04-16 08:57:00'
),
(
    '30000000-0000-0000-0000-000000000057',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    182.37,
    '2025-05-17 08:04:00',
    'Gasto mensual educacion 2025-05',
    '2025-05-17 08:04:00',
    '2025-05-17 08:04:00'
),
(
    '30000000-0000-0000-0000-000000000058',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    189.74,
    '2025-06-18 08:11:00',
    'Gasto mensual entretenimiento 2025-06',
    '2025-06-18 08:11:00',
    '2025-06-18 08:11:00'
),
(
    '30000000-0000-0000-0000-000000000059',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    196.00,
    '2025-07-19 08:18:00',
    'Gasto mensual alimentacion 2025-07',
    '2025-07-19 08:18:00',
    '2025-07-19 08:18:00'
),
(
    '30000000-0000-0000-0000-000000000060',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    203.37,
    '2025-08-20 08:25:00',
    'Gasto mensual transporte 2025-08',
    '2025-08-20 08:25:00',
    '2025-08-20 08:25:00'
),
(
    '30000000-0000-0000-0000-000000000061',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    210.74,
    '2025-09-21 08:32:00',
    'Gasto mensual servicios 2025-09',
    '2025-09-21 08:32:00',
    '2025-09-21 08:32:00'
),
(
    '30000000-0000-0000-0000-000000000062',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    217.00,
    '2025-10-22 08:39:00',
    'Gasto mensual salud 2025-10',
    '2025-10-22 08:39:00',
    '2025-10-22 08:39:00'
),
(
    '30000000-0000-0000-0000-000000000063',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    224.37,
    '2025-11-23 08:46:00',
    'Gasto mensual educacion 2025-11',
    '2025-11-23 08:46:00',
    '2025-11-23 08:46:00'
),
(
    '30000000-0000-0000-0000-000000000064',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    231.74,
    '2025-12-24 08:53:00',
    'Gasto mensual entretenimiento 2025-12',
    '2025-12-24 08:53:00',
    '2025-12-24 08:53:00'
),
(
    '30000000-0000-0000-0000-000000000065',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    51.00,
    '2021-01-06 09:00:00',
    'Gasto mensual transporte 2021-01',
    '2021-01-06 09:00:00',
    '2021-01-06 09:00:00'
),
(
    '30000000-0000-0000-0000-000000000066',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    58.37,
    '2021-02-07 09:07:00',
    'Gasto mensual servicios 2021-02',
    '2021-02-07 09:07:00',
    '2021-02-07 09:07:00'
),
(
    '30000000-0000-0000-0000-000000000067',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    65.74,
    '2021-03-08 09:14:00',
    'Gasto mensual salud 2021-03',
    '2021-03-08 09:14:00',
    '2021-03-08 09:14:00'
),
(
    '30000000-0000-0000-0000-000000000068',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    72.00,
    '2021-04-09 09:21:00',
    'Gasto mensual educacion 2021-04',
    '2021-04-09 09:21:00',
    '2021-04-09 09:21:00'
),
(
    '30000000-0000-0000-0000-000000000069',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    79.37,
    '2021-05-10 09:28:00',
    'Gasto mensual entretenimiento 2021-05',
    '2021-05-10 09:28:00',
    '2021-05-10 09:28:00'
),
(
    '30000000-0000-0000-0000-000000000070',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    68.25,
    '2021-05-13 19:51:00',
    'Gasto adicional servicios 2021-05',
    '2021-05-13 19:51:00',
    '2021-05-13 19:51:00'
),
(
    '30000000-0000-0000-0000-000000000071',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    86.74,
    '2021-06-11 09:35:00',
    'Gasto mensual alimentacion 2021-06',
    '2021-06-11 09:35:00',
    '2021-06-11 09:35:00'
),
(
    '30000000-0000-0000-0000-000000000072',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    93.00,
    '2021-07-12 09:42:00',
    'Gasto mensual transporte 2021-07',
    '2021-07-12 09:42:00',
    '2021-07-12 09:42:00'
),
(
    '30000000-0000-0000-0000-000000000073',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    100.37,
    '2021-08-13 09:49:00',
    'Gasto mensual servicios 2021-08',
    '2021-08-13 09:49:00',
    '2021-08-13 09:49:00'
),
(
    '30000000-0000-0000-0000-000000000074',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    107.74,
    '2021-09-14 09:56:00',
    'Gasto mensual salud 2021-09',
    '2021-09-14 09:56:00',
    '2021-09-14 09:56:00'
),
(
    '30000000-0000-0000-0000-000000000075',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    114.00,
    '2021-10-15 09:03:00',
    'Gasto mensual educacion 2021-10',
    '2021-10-15 09:03:00',
    '2021-10-15 09:03:00'
),
(
    '30000000-0000-0000-0000-000000000076',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    121.37,
    '2021-11-16 09:10:00',
    'Gasto mensual entretenimiento 2021-11',
    '2021-11-16 09:10:00',
    '2021-11-16 09:10:00'
),
(
    '30000000-0000-0000-0000-000000000077',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    98.25,
    '2021-11-19 19:33:00',
    'Gasto adicional servicios 2021-11',
    '2021-11-19 19:33:00',
    '2021-11-19 19:33:00'
),
(
    '30000000-0000-0000-0000-000000000078',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    128.74,
    '2021-12-17 09:17:00',
    'Gasto mensual alimentacion 2021-12',
    '2021-12-17 09:17:00',
    '2021-12-17 09:17:00'
),
(
    '30000000-0000-0000-0000-000000000079',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    135.00,
    '2022-01-18 09:24:00',
    'Gasto mensual transporte 2022-01',
    '2022-01-18 09:24:00',
    '2022-01-18 09:24:00'
),
(
    '30000000-0000-0000-0000-000000000080',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    142.37,
    '2022-02-19 09:31:00',
    'Gasto mensual servicios 2022-02',
    '2022-02-19 09:31:00',
    '2022-02-19 09:31:00'
),
(
    '30000000-0000-0000-0000-000000000081',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    149.74,
    '2022-03-20 09:38:00',
    'Gasto mensual salud 2022-03',
    '2022-03-20 09:38:00',
    '2022-03-20 09:38:00'
),
(
    '30000000-0000-0000-0000-000000000082',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    156.00,
    '2022-04-21 09:45:00',
    'Gasto mensual educacion 2022-04',
    '2022-04-21 09:45:00',
    '2022-04-21 09:45:00'
),
(
    '30000000-0000-0000-0000-000000000083',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    28.25,
    '2022-04-24 19:08:00',
    'Gasto adicional transporte 2022-04',
    '2022-04-24 19:08:00',
    '2022-04-24 19:08:00'
),
(
    '30000000-0000-0000-0000-000000000084',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    163.37,
    '2022-05-22 09:52:00',
    'Gasto mensual entretenimiento 2022-05',
    '2022-05-22 09:52:00',
    '2022-05-22 09:52:00'
),
(
    '30000000-0000-0000-0000-000000000085',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    170.74,
    '2022-06-23 09:59:00',
    'Gasto mensual alimentacion 2022-06',
    '2022-06-23 09:59:00',
    '2022-06-23 09:59:00'
),
(
    '30000000-0000-0000-0000-000000000086',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    177.00,
    '2022-07-24 09:06:00',
    'Gasto mensual transporte 2022-07',
    '2022-07-24 09:06:00',
    '2022-07-24 09:06:00'
),
(
    '30000000-0000-0000-0000-000000000087',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    184.37,
    '2022-08-05 09:13:00',
    'Gasto mensual servicios 2022-08',
    '2022-08-05 09:13:00',
    '2022-08-05 09:13:00'
),
(
    '30000000-0000-0000-0000-000000000088',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    191.74,
    '2022-09-06 09:20:00',
    'Gasto mensual salud 2022-09',
    '2022-09-06 09:20:00',
    '2022-09-06 09:20:00'
),
(
    '30000000-0000-0000-0000-000000000089',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    198.00,
    '2022-10-07 09:27:00',
    'Gasto mensual educacion 2022-10',
    '2022-10-07 09:27:00',
    '2022-10-07 09:27:00'
),
(
    '30000000-0000-0000-0000-000000000090',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    205.37,
    '2022-11-08 09:34:00',
    'Gasto mensual entretenimiento 2022-11',
    '2022-11-08 09:34:00',
    '2022-11-08 09:34:00'
),
(
    '30000000-0000-0000-0000-000000000091',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    212.74,
    '2022-12-09 09:41:00',
    'Gasto mensual alimentacion 2022-12',
    '2022-12-09 09:41:00',
    '2022-12-09 09:41:00'
),
(
    '30000000-0000-0000-0000-000000000092',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    219.00,
    '2023-01-10 09:48:00',
    'Gasto mensual transporte 2023-01',
    '2023-01-10 09:48:00',
    '2023-01-10 09:48:00'
),
(
    '30000000-0000-0000-0000-000000000093',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    226.37,
    '2023-02-11 09:55:00',
    'Gasto mensual servicios 2023-02',
    '2023-02-11 09:55:00',
    '2023-02-11 09:55:00'
),
(
    '30000000-0000-0000-0000-000000000094',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    233.74,
    '2023-03-12 09:02:00',
    'Gasto mensual salud 2023-03',
    '2023-03-12 09:02:00',
    '2023-03-12 09:02:00'
),
(
    '30000000-0000-0000-0000-000000000095',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    83.25,
    '2023-03-15 19:25:00',
    'Gasto adicional alimentacion 2023-03',
    '2023-03-15 19:25:00',
    '2023-03-15 19:25:00'
),
(
    '30000000-0000-0000-0000-000000000096',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    240.00,
    '2023-04-13 09:09:00',
    'Gasto mensual educacion 2023-04',
    '2023-04-13 09:09:00',
    '2023-04-13 09:09:00'
),
(
    '30000000-0000-0000-0000-000000000097',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    27.37,
    '2023-05-14 09:16:00',
    'Gasto mensual entretenimiento 2023-05',
    '2023-05-14 09:16:00',
    '2023-05-14 09:16:00'
),
(
    '30000000-0000-0000-0000-000000000098',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    34.74,
    '2023-06-15 09:23:00',
    'Gasto mensual alimentacion 2023-06',
    '2023-06-15 09:23:00',
    '2023-06-15 09:23:00'
),
(
    '30000000-0000-0000-0000-000000000099',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    41.00,
    '2023-07-16 09:30:00',
    'Gasto mensual transporte 2023-07',
    '2023-07-16 09:30:00',
    '2023-07-16 09:30:00'
),
(
    '30000000-0000-0000-0000-000000000100',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    48.37,
    '2023-08-17 09:37:00',
    'Gasto mensual servicios 2023-08',
    '2023-08-17 09:37:00',
    '2023-08-17 09:37:00'
),
(
    '30000000-0000-0000-0000-000000000101',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    55.74,
    '2023-09-18 09:44:00',
    'Gasto mensual salud 2023-09',
    '2023-09-18 09:44:00',
    '2023-09-18 09:44:00'
),
(
    '30000000-0000-0000-0000-000000000102',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    62.00,
    '2023-10-19 09:51:00',
    'Gasto mensual educacion 2023-10',
    '2023-10-19 09:51:00',
    '2023-10-19 09:51:00'
),
(
    '30000000-0000-0000-0000-000000000103',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    69.37,
    '2023-11-20 09:58:00',
    'Gasto mensual entretenimiento 2023-11',
    '2023-11-20 09:58:00',
    '2023-11-20 09:58:00'
),
(
    '30000000-0000-0000-0000-000000000104',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    76.74,
    '2023-12-21 09:05:00',
    'Gasto mensual alimentacion 2023-12',
    '2023-12-21 09:05:00',
    '2023-12-21 09:05:00'
),
(
    '30000000-0000-0000-0000-000000000105',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    83.00,
    '2024-01-22 09:12:00',
    'Gasto mensual transporte 2024-01',
    '2024-01-22 09:12:00',
    '2024-01-22 09:12:00'
),
(
    '30000000-0000-0000-0000-000000000106',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    90.37,
    '2024-02-23 09:19:00',
    'Gasto mensual servicios 2024-02',
    '2024-02-23 09:19:00',
    '2024-02-23 09:19:00'
),
(
    '30000000-0000-0000-0000-000000000107',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    43.25,
    '2024-02-26 19:42:00',
    'Gasto adicional entretenimiento 2024-02',
    '2024-02-26 19:42:00',
    '2024-02-26 19:42:00'
),
(
    '30000000-0000-0000-0000-000000000108',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    97.74,
    '2024-03-24 09:26:00',
    'Gasto mensual salud 2024-03',
    '2024-03-24 09:26:00',
    '2024-03-24 09:26:00'
),
(
    '30000000-0000-0000-0000-000000000109',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    104.00,
    '2024-04-05 09:33:00',
    'Gasto mensual educacion 2024-04',
    '2024-04-05 09:33:00',
    '2024-04-05 09:33:00'
),
(
    '30000000-0000-0000-0000-000000000110',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    111.37,
    '2024-05-06 09:40:00',
    'Gasto mensual entretenimiento 2024-05',
    '2024-05-06 09:40:00',
    '2024-05-06 09:40:00'
),
(
    '30000000-0000-0000-0000-000000000111',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    118.74,
    '2024-06-07 09:47:00',
    'Gasto mensual alimentacion 2024-06',
    '2024-06-07 09:47:00',
    '2024-06-07 09:47:00'
),
(
    '30000000-0000-0000-0000-000000000112',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    125.00,
    '2024-07-08 09:54:00',
    'Gasto mensual transporte 2024-07',
    '2024-07-08 09:54:00',
    '2024-07-08 09:54:00'
),
(
    '30000000-0000-0000-0000-000000000113',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    132.37,
    '2024-08-09 09:01:00',
    'Gasto mensual servicios 2024-08',
    '2024-08-09 09:01:00',
    '2024-08-09 09:01:00'
),
(
    '30000000-0000-0000-0000-000000000114',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    139.74,
    '2024-09-10 09:08:00',
    'Gasto mensual salud 2024-09',
    '2024-09-10 09:08:00',
    '2024-09-10 09:08:00'
),
(
    '30000000-0000-0000-0000-000000000115',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    146.00,
    '2024-10-11 09:15:00',
    'Gasto mensual educacion 2024-10',
    '2024-10-11 09:15:00',
    '2024-10-11 09:15:00'
),
(
    '30000000-0000-0000-0000-000000000116',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    153.37,
    '2024-11-12 09:22:00',
    'Gasto mensual entretenimiento 2024-11',
    '2024-11-12 09:22:00',
    '2024-11-12 09:22:00'
),
(
    '30000000-0000-0000-0000-000000000117',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    160.74,
    '2024-12-13 09:29:00',
    'Gasto mensual alimentacion 2024-12',
    '2024-12-13 09:29:00',
    '2024-12-13 09:29:00'
),
(
    '30000000-0000-0000-0000-000000000118',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    167.00,
    '2025-01-14 09:36:00',
    'Gasto mensual transporte 2025-01',
    '2025-01-14 09:36:00',
    '2025-01-14 09:36:00'
),
(
    '30000000-0000-0000-0000-000000000119',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    98.25,
    '2025-01-17 19:59:00',
    'Gasto adicional educacion 2025-01',
    '2025-01-17 19:59:00',
    '2025-01-17 19:59:00'
),
(
    '30000000-0000-0000-0000-000000000120',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    174.37,
    '2025-02-15 09:43:00',
    'Gasto mensual servicios 2025-02',
    '2025-02-15 09:43:00',
    '2025-02-15 09:43:00'
),
(
    '30000000-0000-0000-0000-000000000121',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    181.74,
    '2025-03-16 09:50:00',
    'Gasto mensual salud 2025-03',
    '2025-03-16 09:50:00',
    '2025-03-16 09:50:00'
),
(
    '30000000-0000-0000-0000-000000000122',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    188.00,
    '2025-04-17 09:57:00',
    'Gasto mensual educacion 2025-04',
    '2025-04-17 09:57:00',
    '2025-04-17 09:57:00'
),
(
    '30000000-0000-0000-0000-000000000123',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    195.37,
    '2025-05-18 09:04:00',
    'Gasto mensual entretenimiento 2025-05',
    '2025-05-18 09:04:00',
    '2025-05-18 09:04:00'
),
(
    '30000000-0000-0000-0000-000000000124',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    202.74,
    '2025-06-19 09:11:00',
    'Gasto mensual alimentacion 2025-06',
    '2025-06-19 09:11:00',
    '2025-06-19 09:11:00'
),
(
    '30000000-0000-0000-0000-000000000125',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    28.25,
    '2025-06-22 19:34:00',
    'Gasto adicional salud 2025-06',
    '2025-06-22 19:34:00',
    '2025-06-22 19:34:00'
),
(
    '30000000-0000-0000-0000-000000000126',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    209.00,
    '2025-07-20 09:18:00',
    'Gasto mensual transporte 2025-07',
    '2025-07-20 09:18:00',
    '2025-07-20 09:18:00'
),
(
    '30000000-0000-0000-0000-000000000127',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    216.37,
    '2025-08-21 09:25:00',
    'Gasto mensual servicios 2025-08',
    '2025-08-21 09:25:00',
    '2025-08-21 09:25:00'
),
(
    '30000000-0000-0000-0000-000000000128',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    223.74,
    '2025-09-22 09:32:00',
    'Gasto mensual salud 2025-09',
    '2025-09-22 09:32:00',
    '2025-09-22 09:32:00'
),
(
    '30000000-0000-0000-0000-000000000129',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    230.00,
    '2025-10-23 09:39:00',
    'Gasto mensual educacion 2025-10',
    '2025-10-23 09:39:00',
    '2025-10-23 09:39:00'
),
(
    '30000000-0000-0000-0000-000000000130',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    237.37,
    '2025-11-24 09:46:00',
    'Gasto mensual entretenimiento 2025-11',
    '2025-11-24 09:46:00',
    '2025-11-24 09:46:00'
),
(
    '30000000-0000-0000-0000-000000000131',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    244.74,
    '2025-12-05 09:53:00',
    'Gasto mensual alimentacion 2025-12',
    '2025-12-05 09:53:00',
    '2025-12-05 09:53:00'
),
(
    '30000000-0000-0000-0000-000000000132',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    58.25,
    '2025-12-08 19:16:00',
    'Gasto adicional salud 2025-12',
    '2025-12-08 19:16:00',
    '2025-12-08 19:16:00'
),
(
    '30000000-0000-0000-0000-000000000133',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    64.00,
    '2021-01-07 10:00:00',
    'Gasto mensual servicios 2021-01',
    '2021-01-07 10:00:00',
    '2021-01-07 10:00:00'
),
(
    '30000000-0000-0000-0000-000000000134',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    71.37,
    '2021-02-08 10:07:00',
    'Gasto mensual salud 2021-02',
    '2021-02-08 10:07:00',
    '2021-02-08 10:07:00'
),
(
    '30000000-0000-0000-0000-000000000135',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    78.74,
    '2021-03-09 10:14:00',
    'Gasto mensual educacion 2021-03',
    '2021-03-09 10:14:00',
    '2021-03-09 10:14:00'
),
(
    '30000000-0000-0000-0000-000000000136',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    85.00,
    '2021-04-10 10:21:00',
    'Gasto mensual entretenimiento 2021-04',
    '2021-04-10 10:21:00',
    '2021-04-10 10:21:00'
),
(
    '30000000-0000-0000-0000-000000000137',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    72.50,
    '2021-04-13 19:44:00',
    'Gasto adicional servicios 2021-04',
    '2021-04-13 19:44:00',
    '2021-04-13 19:44:00'
),
(
    '30000000-0000-0000-0000-000000000138',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    92.37,
    '2021-05-11 10:28:00',
    'Gasto mensual alimentacion 2021-05',
    '2021-05-11 10:28:00',
    '2021-05-11 10:28:00'
),
(
    '30000000-0000-0000-0000-000000000139',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    99.74,
    '2021-06-12 10:35:00',
    'Gasto mensual transporte 2021-06',
    '2021-06-12 10:35:00',
    '2021-06-12 10:35:00'
),
(
    '30000000-0000-0000-0000-000000000140',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    106.00,
    '2021-07-13 10:42:00',
    'Gasto mensual servicios 2021-07',
    '2021-07-13 10:42:00',
    '2021-07-13 10:42:00'
),
(
    '30000000-0000-0000-0000-000000000141',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    113.37,
    '2021-08-14 10:49:00',
    'Gasto mensual salud 2021-08',
    '2021-08-14 10:49:00',
    '2021-08-14 10:49:00'
),
(
    '30000000-0000-0000-0000-000000000142',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    120.74,
    '2021-09-15 10:56:00',
    'Gasto mensual educacion 2021-09',
    '2021-09-15 10:56:00',
    '2021-09-15 10:56:00'
),
(
    '30000000-0000-0000-0000-000000000143',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    97.50,
    '2021-09-18 19:19:00',
    'Gasto adicional transporte 2021-09',
    '2021-09-18 19:19:00',
    '2021-09-18 19:19:00'
),
(
    '30000000-0000-0000-0000-000000000144',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    127.00,
    '2021-10-16 10:03:00',
    'Gasto mensual entretenimiento 2021-10',
    '2021-10-16 10:03:00',
    '2021-10-16 10:03:00'
),
(
    '30000000-0000-0000-0000-000000000145',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    134.37,
    '2021-11-17 10:10:00',
    'Gasto mensual alimentacion 2021-11',
    '2021-11-17 10:10:00',
    '2021-11-17 10:10:00'
),
(
    '30000000-0000-0000-0000-000000000146',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    141.74,
    '2021-12-18 10:17:00',
    'Gasto mensual transporte 2021-12',
    '2021-12-18 10:17:00',
    '2021-12-18 10:17:00'
),
(
    '30000000-0000-0000-0000-000000000147',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    148.00,
    '2022-01-19 10:24:00',
    'Gasto mensual servicios 2022-01',
    '2022-01-19 10:24:00',
    '2022-01-19 10:24:00'
),
(
    '30000000-0000-0000-0000-000000000148',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    155.37,
    '2022-02-20 10:31:00',
    'Gasto mensual salud 2022-02',
    '2022-02-20 10:31:00',
    '2022-02-20 10:31:00'
),
(
    '30000000-0000-0000-0000-000000000149',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    162.74,
    '2022-03-21 10:38:00',
    'Gasto mensual educacion 2022-03',
    '2022-03-21 10:38:00',
    '2022-03-21 10:38:00'
),
(
    '30000000-0000-0000-0000-000000000150',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    32.50,
    '2022-03-24 19:01:00',
    'Gasto adicional transporte 2022-03',
    '2022-03-24 19:01:00',
    '2022-03-24 19:01:00'
),
(
    '30000000-0000-0000-0000-000000000151',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    169.00,
    '2022-04-22 10:45:00',
    'Gasto mensual entretenimiento 2022-04',
    '2022-04-22 10:45:00',
    '2022-04-22 10:45:00'
),
(
    '30000000-0000-0000-0000-000000000152',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    176.37,
    '2022-05-23 10:52:00',
    'Gasto mensual alimentacion 2022-05',
    '2022-05-23 10:52:00',
    '2022-05-23 10:52:00'
),
(
    '30000000-0000-0000-0000-000000000153',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    183.74,
    '2022-06-24 10:59:00',
    'Gasto mensual transporte 2022-06',
    '2022-06-24 10:59:00',
    '2022-06-24 10:59:00'
),
(
    '30000000-0000-0000-0000-000000000154',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    190.00,
    '2022-07-05 10:06:00',
    'Gasto mensual servicios 2022-07',
    '2022-07-05 10:06:00',
    '2022-07-05 10:06:00'
),
(
    '30000000-0000-0000-0000-000000000155',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    197.37,
    '2022-08-06 10:13:00',
    'Gasto mensual salud 2022-08',
    '2022-08-06 10:13:00',
    '2022-08-06 10:13:00'
),
(
    '30000000-0000-0000-0000-000000000156',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    57.50,
    '2022-08-09 19:36:00',
    'Gasto adicional alimentacion 2022-08',
    '2022-08-09 19:36:00',
    '2022-08-09 19:36:00'
),
(
    '30000000-0000-0000-0000-000000000157',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    204.74,
    '2022-09-07 10:20:00',
    'Gasto mensual educacion 2022-09',
    '2022-09-07 10:20:00',
    '2022-09-07 10:20:00'
),
(
    '30000000-0000-0000-0000-000000000158',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    211.00,
    '2022-10-08 10:27:00',
    'Gasto mensual entretenimiento 2022-10',
    '2022-10-08 10:27:00',
    '2022-10-08 10:27:00'
),
(
    '30000000-0000-0000-0000-000000000159',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    218.37,
    '2022-11-09 10:34:00',
    'Gasto mensual alimentacion 2022-11',
    '2022-11-09 10:34:00',
    '2022-11-09 10:34:00'
),
(
    '30000000-0000-0000-0000-000000000160',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    225.74,
    '2022-12-10 10:41:00',
    'Gasto mensual transporte 2022-12',
    '2022-12-10 10:41:00',
    '2022-12-10 10:41:00'
),
(
    '30000000-0000-0000-0000-000000000161',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    232.00,
    '2023-01-11 10:48:00',
    'Gasto mensual servicios 2023-01',
    '2023-01-11 10:48:00',
    '2023-01-11 10:48:00'
),
(
    '30000000-0000-0000-0000-000000000162',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    239.37,
    '2023-02-12 10:55:00',
    'Gasto mensual salud 2023-02',
    '2023-02-12 10:55:00',
    '2023-02-12 10:55:00'
),
(
    '30000000-0000-0000-0000-000000000163',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    87.50,
    '2023-02-15 19:18:00',
    'Gasto adicional alimentacion 2023-02',
    '2023-02-15 19:18:00',
    '2023-02-15 19:18:00'
),
(
    '30000000-0000-0000-0000-000000000164',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    26.74,
    '2023-03-13 10:02:00',
    'Gasto mensual educacion 2023-03',
    '2023-03-13 10:02:00',
    '2023-03-13 10:02:00'
),
(
    '30000000-0000-0000-0000-000000000165',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    33.00,
    '2023-04-14 10:09:00',
    'Gasto mensual entretenimiento 2023-04',
    '2023-04-14 10:09:00',
    '2023-04-14 10:09:00'
),
(
    '30000000-0000-0000-0000-000000000166',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    40.37,
    '2023-05-15 10:16:00',
    'Gasto mensual alimentacion 2023-05',
    '2023-05-15 10:16:00',
    '2023-05-15 10:16:00'
),
(
    '30000000-0000-0000-0000-000000000167',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    47.74,
    '2023-06-16 10:23:00',
    'Gasto mensual transporte 2023-06',
    '2023-06-16 10:23:00',
    '2023-06-16 10:23:00'
),
(
    '30000000-0000-0000-0000-000000000168',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    54.00,
    '2023-07-17 10:30:00',
    'Gasto mensual servicios 2023-07',
    '2023-07-17 10:30:00',
    '2023-07-17 10:30:00'
),
(
    '30000000-0000-0000-0000-000000000169',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    17.50,
    '2023-07-20 19:53:00',
    'Gasto adicional entretenimiento 2023-07',
    '2023-07-20 19:53:00',
    '2023-07-20 19:53:00'
),
(
    '30000000-0000-0000-0000-000000000170',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    61.37,
    '2023-08-18 10:37:00',
    'Gasto mensual salud 2023-08',
    '2023-08-18 10:37:00',
    '2023-08-18 10:37:00'
),
(
    '30000000-0000-0000-0000-000000000171',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    68.74,
    '2023-09-19 10:44:00',
    'Gasto mensual educacion 2023-09',
    '2023-09-19 10:44:00',
    '2023-09-19 10:44:00'
),
(
    '30000000-0000-0000-0000-000000000172',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    75.00,
    '2023-10-20 10:51:00',
    'Gasto mensual entretenimiento 2023-10',
    '2023-10-20 10:51:00',
    '2023-10-20 10:51:00'
),
(
    '30000000-0000-0000-0000-000000000173',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    82.37,
    '2023-11-21 10:58:00',
    'Gasto mensual alimentacion 2023-11',
    '2023-11-21 10:58:00',
    '2023-11-21 10:58:00'
),
(
    '30000000-0000-0000-0000-000000000174',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    89.74,
    '2023-12-22 10:05:00',
    'Gasto mensual transporte 2023-12',
    '2023-12-22 10:05:00',
    '2023-12-22 10:05:00'
),
(
    '30000000-0000-0000-0000-000000000175',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    96.00,
    '2024-01-23 10:12:00',
    'Gasto mensual servicios 2024-01',
    '2024-01-23 10:12:00',
    '2024-01-23 10:12:00'
),
(
    '30000000-0000-0000-0000-000000000176',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    47.50,
    '2024-01-26 19:35:00',
    'Gasto adicional entretenimiento 2024-01',
    '2024-01-26 19:35:00',
    '2024-01-26 19:35:00'
),
(
    '30000000-0000-0000-0000-000000000177',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    103.37,
    '2024-02-24 10:19:00',
    'Gasto mensual salud 2024-02',
    '2024-02-24 10:19:00',
    '2024-02-24 10:19:00'
),
(
    '30000000-0000-0000-0000-000000000178',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    110.74,
    '2024-03-05 10:26:00',
    'Gasto mensual educacion 2024-03',
    '2024-03-05 10:26:00',
    '2024-03-05 10:26:00'
),
(
    '30000000-0000-0000-0000-000000000179',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    117.00,
    '2024-04-06 10:33:00',
    'Gasto mensual entretenimiento 2024-04',
    '2024-04-06 10:33:00',
    '2024-04-06 10:33:00'
),
(
    '30000000-0000-0000-0000-000000000180',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    124.37,
    '2024-05-07 10:40:00',
    'Gasto mensual alimentacion 2024-05',
    '2024-05-07 10:40:00',
    '2024-05-07 10:40:00'
),
(
    '30000000-0000-0000-0000-000000000181',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    131.74,
    '2024-06-08 10:47:00',
    'Gasto mensual transporte 2024-06',
    '2024-06-08 10:47:00',
    '2024-06-08 10:47:00'
),
(
    '30000000-0000-0000-0000-000000000182',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    72.50,
    '2024-06-11 19:10:00',
    'Gasto adicional educacion 2024-06',
    '2024-06-11 19:10:00',
    '2024-06-11 19:10:00'
),
(
    '30000000-0000-0000-0000-000000000183',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    138.00,
    '2024-07-09 10:54:00',
    'Gasto mensual servicios 2024-07',
    '2024-07-09 10:54:00',
    '2024-07-09 10:54:00'
),
(
    '30000000-0000-0000-0000-000000000184',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    145.37,
    '2024-08-10 10:01:00',
    'Gasto mensual salud 2024-08',
    '2024-08-10 10:01:00',
    '2024-08-10 10:01:00'
),
(
    '30000000-0000-0000-0000-000000000185',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    152.74,
    '2024-09-11 10:08:00',
    'Gasto mensual educacion 2024-09',
    '2024-09-11 10:08:00',
    '2024-09-11 10:08:00'
),
(
    '30000000-0000-0000-0000-000000000186',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    159.00,
    '2024-10-12 10:15:00',
    'Gasto mensual entretenimiento 2024-10',
    '2024-10-12 10:15:00',
    '2024-10-12 10:15:00'
),
(
    '30000000-0000-0000-0000-000000000187',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    166.37,
    '2024-11-13 10:22:00',
    'Gasto mensual alimentacion 2024-11',
    '2024-11-13 10:22:00',
    '2024-11-13 10:22:00'
),
(
    '30000000-0000-0000-0000-000000000188',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    97.50,
    '2024-11-16 19:45:00',
    'Gasto adicional salud 2024-11',
    '2024-11-16 19:45:00',
    '2024-11-16 19:45:00'
),
(
    '30000000-0000-0000-0000-000000000189',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    173.74,
    '2024-12-14 10:29:00',
    'Gasto mensual transporte 2024-12',
    '2024-12-14 10:29:00',
    '2024-12-14 10:29:00'
),
(
    '30000000-0000-0000-0000-000000000190',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    102.50,
    '2024-12-17 19:52:00',
    'Gasto adicional educacion 2024-12',
    '2024-12-17 19:52:00',
    '2024-12-17 19:52:00'
),
(
    '30000000-0000-0000-0000-000000000191',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    180.00,
    '2025-01-15 10:36:00',
    'Gasto mensual servicios 2025-01',
    '2025-01-15 10:36:00',
    '2025-01-15 10:36:00'
),
(
    '30000000-0000-0000-0000-000000000192',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    187.37,
    '2025-02-16 10:43:00',
    'Gasto mensual salud 2025-02',
    '2025-02-16 10:43:00',
    '2025-02-16 10:43:00'
),
(
    '30000000-0000-0000-0000-000000000193',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    194.74,
    '2025-03-17 10:50:00',
    'Gasto mensual educacion 2025-03',
    '2025-03-17 10:50:00',
    '2025-03-17 10:50:00'
),
(
    '30000000-0000-0000-0000-000000000194',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    201.00,
    '2025-04-18 10:57:00',
    'Gasto mensual entretenimiento 2025-04',
    '2025-04-18 10:57:00',
    '2025-04-18 10:57:00'
),
(
    '30000000-0000-0000-0000-000000000195',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    208.37,
    '2025-05-19 10:04:00',
    'Gasto mensual alimentacion 2025-05',
    '2025-05-19 10:04:00',
    '2025-05-19 10:04:00'
),
(
    '30000000-0000-0000-0000-000000000196',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    32.50,
    '2025-05-22 19:27:00',
    'Gasto adicional salud 2025-05',
    '2025-05-22 19:27:00',
    '2025-05-22 19:27:00'
),
(
    '30000000-0000-0000-0000-000000000197',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    215.74,
    '2025-06-20 10:11:00',
    'Gasto mensual transporte 2025-06',
    '2025-06-20 10:11:00',
    '2025-06-20 10:11:00'
),
(
    '30000000-0000-0000-0000-000000000198',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    222.00,
    '2025-07-21 10:18:00',
    'Gasto mensual servicios 2025-07',
    '2025-07-21 10:18:00',
    '2025-07-21 10:18:00'
),
(
    '30000000-0000-0000-0000-000000000199',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    229.37,
    '2025-08-22 10:25:00',
    'Gasto mensual salud 2025-08',
    '2025-08-22 10:25:00',
    '2025-08-22 10:25:00'
),
(
    '30000000-0000-0000-0000-000000000200',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    236.74,
    '2025-09-23 10:32:00',
    'Gasto mensual educacion 2025-09',
    '2025-09-23 10:32:00',
    '2025-09-23 10:32:00'
),
(
    '30000000-0000-0000-0000-000000000201',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    243.00,
    '2025-10-24 10:39:00',
    'Gasto mensual entretenimiento 2025-10',
    '2025-10-24 10:39:00',
    '2025-10-24 10:39:00'
),
(
    '30000000-0000-0000-0000-000000000202',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    57.50,
    '2025-10-27 19:02:00',
    'Gasto adicional servicios 2025-10',
    '2025-10-27 19:02:00',
    '2025-10-27 19:02:00'
),
(
    '30000000-0000-0000-0000-000000000203',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    30.37,
    '2025-11-05 10:46:00',
    'Gasto mensual alimentacion 2025-11',
    '2025-11-05 10:46:00',
    '2025-11-05 10:46:00'
),
(
    '30000000-0000-0000-0000-000000000204',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    37.74,
    '2025-12-06 10:53:00',
    'Gasto mensual transporte 2025-12',
    '2025-12-06 10:53:00',
    '2025-12-06 10:53:00'
),
(
    '30000000-0000-0000-0000-000000000205',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    77.00,
    '2021-01-08 11:00:00',
    'Gasto mensual salud 2021-01',
    '2021-01-08 11:00:00',
    '2021-01-08 11:00:00'
),
(
    '30000000-0000-0000-0000-000000000206',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    84.37,
    '2021-02-09 11:07:00',
    'Gasto mensual educacion 2021-02',
    '2021-02-09 11:07:00',
    '2021-02-09 11:07:00'
),
(
    '30000000-0000-0000-0000-000000000207',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    71.75,
    '2021-02-12 19:30:00',
    'Gasto adicional transporte 2021-02',
    '2021-02-12 19:30:00',
    '2021-02-12 19:30:00'
),
(
    '30000000-0000-0000-0000-000000000208',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    91.74,
    '2021-03-10 11:14:00',
    'Gasto mensual entretenimiento 2021-03',
    '2021-03-10 11:14:00',
    '2021-03-10 11:14:00'
),
(
    '30000000-0000-0000-0000-000000000209',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    76.75,
    '2021-03-13 19:37:00',
    'Gasto adicional servicios 2021-03',
    '2021-03-13 19:37:00',
    '2021-03-13 19:37:00'
),
(
    '30000000-0000-0000-0000-000000000210',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    98.00,
    '2021-04-11 11:21:00',
    'Gasto mensual alimentacion 2021-04',
    '2021-04-11 11:21:00',
    '2021-04-11 11:21:00'
),
(
    '30000000-0000-0000-0000-000000000211',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    105.37,
    '2021-05-12 11:28:00',
    'Gasto mensual transporte 2021-05',
    '2021-05-12 11:28:00',
    '2021-05-12 11:28:00'
),
(
    '30000000-0000-0000-0000-000000000212',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    112.74,
    '2021-06-13 11:35:00',
    'Gasto mensual servicios 2021-06',
    '2021-06-13 11:35:00',
    '2021-06-13 11:35:00'
),
(
    '30000000-0000-0000-0000-000000000213',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    119.00,
    '2021-07-14 11:42:00',
    'Gasto mensual salud 2021-07',
    '2021-07-14 11:42:00',
    '2021-07-14 11:42:00'
),
(
    '30000000-0000-0000-0000-000000000214',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    126.37,
    '2021-08-15 11:49:00',
    'Gasto mensual educacion 2021-08',
    '2021-08-15 11:49:00',
    '2021-08-15 11:49:00'
),
(
    '30000000-0000-0000-0000-000000000215',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    101.75,
    '2021-08-18 19:12:00',
    'Gasto adicional transporte 2021-08',
    '2021-08-18 19:12:00',
    '2021-08-18 19:12:00'
),
(
    '30000000-0000-0000-0000-000000000216',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    133.74,
    '2021-09-16 11:56:00',
    'Gasto mensual entretenimiento 2021-09',
    '2021-09-16 11:56:00',
    '2021-09-16 11:56:00'
),
(
    '30000000-0000-0000-0000-000000000217',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    106.75,
    '2021-09-19 19:19:00',
    'Gasto adicional servicios 2021-09',
    '2021-09-19 19:19:00',
    '2021-09-19 19:19:00'
),
(
    '30000000-0000-0000-0000-000000000218',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    140.00,
    '2021-10-17 11:03:00',
    'Gasto mensual alimentacion 2021-10',
    '2021-10-17 11:03:00',
    '2021-10-17 11:03:00'
),
(
    '30000000-0000-0000-0000-000000000219',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    147.37,
    '2021-11-18 11:10:00',
    'Gasto mensual transporte 2021-11',
    '2021-11-18 11:10:00',
    '2021-11-18 11:10:00'
),
(
    '30000000-0000-0000-0000-000000000220',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    154.74,
    '2021-12-19 11:17:00',
    'Gasto mensual servicios 2021-12',
    '2021-12-19 11:17:00',
    '2021-12-19 11:17:00'
),
(
    '30000000-0000-0000-0000-000000000221',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    161.00,
    '2022-01-20 11:24:00',
    'Gasto mensual salud 2022-01',
    '2022-01-20 11:24:00',
    '2022-01-20 11:24:00'
),
(
    '30000000-0000-0000-0000-000000000222',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    31.75,
    '2022-01-23 19:47:00',
    'Gasto adicional alimentacion 2022-01',
    '2022-01-23 19:47:00',
    '2022-01-23 19:47:00'
),
(
    '30000000-0000-0000-0000-000000000223',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    168.37,
    '2022-02-21 11:31:00',
    'Gasto mensual educacion 2022-02',
    '2022-02-21 11:31:00',
    '2022-02-21 11:31:00'
),
(
    '30000000-0000-0000-0000-000000000224',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    36.75,
    '2022-02-24 19:54:00',
    'Gasto adicional transporte 2022-02',
    '2022-02-24 19:54:00',
    '2022-02-24 19:54:00'
),
(
    '30000000-0000-0000-0000-000000000225',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    175.74,
    '2022-03-22 11:38:00',
    'Gasto mensual entretenimiento 2022-03',
    '2022-03-22 11:38:00',
    '2022-03-22 11:38:00'
),
(
    '30000000-0000-0000-0000-000000000226',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    182.00,
    '2022-04-23 11:45:00',
    'Gasto mensual alimentacion 2022-04',
    '2022-04-23 11:45:00',
    '2022-04-23 11:45:00'
),
(
    '30000000-0000-0000-0000-000000000227',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    189.37,
    '2022-05-24 11:52:00',
    'Gasto mensual transporte 2022-05',
    '2022-05-24 11:52:00',
    '2022-05-24 11:52:00'
),
(
    '30000000-0000-0000-0000-000000000228',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    196.74,
    '2022-06-05 11:59:00',
    'Gasto mensual servicios 2022-06',
    '2022-06-05 11:59:00',
    '2022-06-05 11:59:00'
),
(
    '30000000-0000-0000-0000-000000000229',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    203.00,
    '2022-07-06 11:06:00',
    'Gasto mensual salud 2022-07',
    '2022-07-06 11:06:00',
    '2022-07-06 11:06:00'
),
(
    '30000000-0000-0000-0000-000000000230',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    61.75,
    '2022-07-09 19:29:00',
    'Gasto adicional alimentacion 2022-07',
    '2022-07-09 19:29:00',
    '2022-07-09 19:29:00'
),
(
    '30000000-0000-0000-0000-000000000231',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    210.37,
    '2022-08-07 11:13:00',
    'Gasto mensual educacion 2022-08',
    '2022-08-07 11:13:00',
    '2022-08-07 11:13:00'
),
(
    '30000000-0000-0000-0000-000000000232',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    66.75,
    '2022-08-10 19:36:00',
    'Gasto adicional transporte 2022-08',
    '2022-08-10 19:36:00',
    '2022-08-10 19:36:00'
),
(
    '30000000-0000-0000-0000-000000000233',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    217.74,
    '2022-09-08 11:20:00',
    'Gasto mensual entretenimiento 2022-09',
    '2022-09-08 11:20:00',
    '2022-09-08 11:20:00'
),
(
    '30000000-0000-0000-0000-000000000234',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    224.00,
    '2022-10-09 11:27:00',
    'Gasto mensual alimentacion 2022-10',
    '2022-10-09 11:27:00',
    '2022-10-09 11:27:00'
),
(
    '30000000-0000-0000-0000-000000000235',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    231.37,
    '2022-11-10 11:34:00',
    'Gasto mensual transporte 2022-11',
    '2022-11-10 11:34:00',
    '2022-11-10 11:34:00'
),
(
    '30000000-0000-0000-0000-000000000236',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    238.74,
    '2022-12-11 11:41:00',
    'Gasto mensual servicios 2022-12',
    '2022-12-11 11:41:00',
    '2022-12-11 11:41:00'
),
(
    '30000000-0000-0000-0000-000000000237',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    86.75,
    '2022-12-14 19:04:00',
    'Gasto adicional entretenimiento 2022-12',
    '2022-12-14 19:04:00',
    '2022-12-14 19:04:00'
),
(
    '30000000-0000-0000-0000-000000000238',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    25.00,
    '2023-01-12 11:48:00',
    'Gasto mensual salud 2023-01',
    '2023-01-12 11:48:00',
    '2023-01-12 11:48:00'
),
(
    '30000000-0000-0000-0000-000000000239',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    91.75,
    '2023-01-15 19:11:00',
    'Gasto adicional alimentacion 2023-01',
    '2023-01-15 19:11:00',
    '2023-01-15 19:11:00'
),
(
    '30000000-0000-0000-0000-000000000240',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    32.37,
    '2023-02-13 11:55:00',
    'Gasto mensual educacion 2023-02',
    '2023-02-13 11:55:00',
    '2023-02-13 11:55:00'
),
(
    '30000000-0000-0000-0000-000000000241',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    39.74,
    '2023-03-14 11:02:00',
    'Gasto mensual entretenimiento 2023-03',
    '2023-03-14 11:02:00',
    '2023-03-14 11:02:00'
),
(
    '30000000-0000-0000-0000-000000000242',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    46.00,
    '2023-04-15 11:09:00',
    'Gasto mensual alimentacion 2023-04',
    '2023-04-15 11:09:00',
    '2023-04-15 11:09:00'
),
(
    '30000000-0000-0000-0000-000000000243',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    53.37,
    '2023-05-16 11:16:00',
    'Gasto mensual transporte 2023-05',
    '2023-05-16 11:16:00',
    '2023-05-16 11:16:00'
),
(
    '30000000-0000-0000-0000-000000000244',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    60.74,
    '2023-06-17 11:23:00',
    'Gasto mensual servicios 2023-06',
    '2023-06-17 11:23:00',
    '2023-06-17 11:23:00'
),
(
    '30000000-0000-0000-0000-000000000245',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    21.75,
    '2023-06-20 19:46:00',
    'Gasto adicional entretenimiento 2023-06',
    '2023-06-20 19:46:00',
    '2023-06-20 19:46:00'
),
(
    '30000000-0000-0000-0000-000000000246',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    67.00,
    '2023-07-18 11:30:00',
    'Gasto mensual salud 2023-07',
    '2023-07-18 11:30:00',
    '2023-07-18 11:30:00'
),
(
    '30000000-0000-0000-0000-000000000247',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    26.75,
    '2023-07-21 19:53:00',
    'Gasto adicional alimentacion 2023-07',
    '2023-07-21 19:53:00',
    '2023-07-21 19:53:00'
),
(
    '30000000-0000-0000-0000-000000000248',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    74.37,
    '2023-08-19 11:37:00',
    'Gasto mensual educacion 2023-08',
    '2023-08-19 11:37:00',
    '2023-08-19 11:37:00'
),
(
    '30000000-0000-0000-0000-000000000249',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    81.74,
    '2023-09-20 11:44:00',
    'Gasto mensual entretenimiento 2023-09',
    '2023-09-20 11:44:00',
    '2023-09-20 11:44:00'
),
(
    '30000000-0000-0000-0000-000000000250',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    88.00,
    '2023-10-21 11:51:00',
    'Gasto mensual alimentacion 2023-10',
    '2023-10-21 11:51:00',
    '2023-10-21 11:51:00'
),
(
    '30000000-0000-0000-0000-000000000251',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    95.37,
    '2023-11-22 11:58:00',
    'Gasto mensual transporte 2023-11',
    '2023-11-22 11:58:00',
    '2023-11-22 11:58:00'
),
(
    '30000000-0000-0000-0000-000000000252',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    46.75,
    '2023-11-25 19:21:00',
    'Gasto adicional educacion 2023-11',
    '2023-11-25 19:21:00',
    '2023-11-25 19:21:00'
),
(
    '30000000-0000-0000-0000-000000000253',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    102.74,
    '2023-12-23 11:05:00',
    'Gasto mensual servicios 2023-12',
    '2023-12-23 11:05:00',
    '2023-12-23 11:05:00'
),
(
    '30000000-0000-0000-0000-000000000254',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    51.75,
    '2023-12-26 19:28:00',
    'Gasto adicional entretenimiento 2023-12',
    '2023-12-26 19:28:00',
    '2023-12-26 19:28:00'
),
(
    '30000000-0000-0000-0000-000000000255',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    109.00,
    '2024-01-24 11:12:00',
    'Gasto mensual salud 2024-01',
    '2024-01-24 11:12:00',
    '2024-01-24 11:12:00'
),
(
    '30000000-0000-0000-0000-000000000256',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    116.37,
    '2024-02-05 11:19:00',
    'Gasto mensual educacion 2024-02',
    '2024-02-05 11:19:00',
    '2024-02-05 11:19:00'
),
(
    '30000000-0000-0000-0000-000000000257',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    123.74,
    '2024-03-06 11:26:00',
    'Gasto mensual entretenimiento 2024-03',
    '2024-03-06 11:26:00',
    '2024-03-06 11:26:00'
),
(
    '30000000-0000-0000-0000-000000000258',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    130.00,
    '2024-04-07 11:33:00',
    'Gasto mensual alimentacion 2024-04',
    '2024-04-07 11:33:00',
    '2024-04-07 11:33:00'
),
(
    '30000000-0000-0000-0000-000000000259',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    71.75,
    '2024-04-10 19:56:00',
    'Gasto adicional salud 2024-04',
    '2024-04-10 19:56:00',
    '2024-04-10 19:56:00'
),
(
    '30000000-0000-0000-0000-000000000260',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    137.37,
    '2024-05-08 11:40:00',
    'Gasto mensual transporte 2024-05',
    '2024-05-08 11:40:00',
    '2024-05-08 11:40:00'
),
(
    '30000000-0000-0000-0000-000000000261',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    76.75,
    '2024-05-11 19:03:00',
    'Gasto adicional educacion 2024-05',
    '2024-05-11 19:03:00',
    '2024-05-11 19:03:00'
),
(
    '30000000-0000-0000-0000-000000000262',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    144.74,
    '2024-06-09 11:47:00',
    'Gasto mensual servicios 2024-06',
    '2024-06-09 11:47:00',
    '2024-06-09 11:47:00'
),
(
    '30000000-0000-0000-0000-000000000263',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    81.75,
    '2024-06-12 19:10:00',
    'Gasto adicional entretenimiento 2024-06',
    '2024-06-12 19:10:00',
    '2024-06-12 19:10:00'
),
(
    '30000000-0000-0000-0000-000000000264',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    151.00,
    '2024-07-10 11:54:00',
    'Gasto mensual salud 2024-07',
    '2024-07-10 11:54:00',
    '2024-07-10 11:54:00'
),
(
    '30000000-0000-0000-0000-000000000265',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    158.37,
    '2024-08-11 11:01:00',
    'Gasto mensual educacion 2024-08',
    '2024-08-11 11:01:00',
    '2024-08-11 11:01:00'
),
(
    '30000000-0000-0000-0000-000000000266',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    165.74,
    '2024-09-12 11:08:00',
    'Gasto mensual entretenimiento 2024-09',
    '2024-09-12 11:08:00',
    '2024-09-12 11:08:00'
),
(
    '30000000-0000-0000-0000-000000000267',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    172.00,
    '2024-10-13 11:15:00',
    'Gasto mensual alimentacion 2024-10',
    '2024-10-13 11:15:00',
    '2024-10-13 11:15:00'
),
(
    '30000000-0000-0000-0000-000000000268',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    101.75,
    '2024-10-16 19:38:00',
    'Gasto adicional salud 2024-10',
    '2024-10-16 19:38:00',
    '2024-10-16 19:38:00'
),
(
    '30000000-0000-0000-0000-000000000269',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    179.37,
    '2024-11-14 11:22:00',
    'Gasto mensual transporte 2024-11',
    '2024-11-14 11:22:00',
    '2024-11-14 11:22:00'
),
(
    '30000000-0000-0000-0000-000000000270',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    106.75,
    '2024-11-17 19:45:00',
    'Gasto adicional educacion 2024-11',
    '2024-11-17 19:45:00',
    '2024-11-17 19:45:00'
),
(
    '30000000-0000-0000-0000-000000000271',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    186.74,
    '2024-12-15 11:29:00',
    'Gasto mensual servicios 2024-12',
    '2024-12-15 11:29:00',
    '2024-12-15 11:29:00'
),
(
    '30000000-0000-0000-0000-000000000272',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    193.00,
    '2025-01-16 11:36:00',
    'Gasto mensual salud 2025-01',
    '2025-01-16 11:36:00',
    '2025-01-16 11:36:00'
),
(
    '30000000-0000-0000-0000-000000000273',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    200.37,
    '2025-02-17 11:43:00',
    'Gasto mensual educacion 2025-02',
    '2025-02-17 11:43:00',
    '2025-02-17 11:43:00'
),
(
    '30000000-0000-0000-0000-000000000274',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    207.74,
    '2025-03-18 11:50:00',
    'Gasto mensual entretenimiento 2025-03',
    '2025-03-18 11:50:00',
    '2025-03-18 11:50:00'
),
(
    '30000000-0000-0000-0000-000000000275',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    31.75,
    '2025-03-21 19:13:00',
    'Gasto adicional servicios 2025-03',
    '2025-03-21 19:13:00',
    '2025-03-21 19:13:00'
),
(
    '30000000-0000-0000-0000-000000000276',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    214.00,
    '2025-04-19 11:57:00',
    'Gasto mensual alimentacion 2025-04',
    '2025-04-19 11:57:00',
    '2025-04-19 11:57:00'
),
(
    '30000000-0000-0000-0000-000000000277',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    36.75,
    '2025-04-22 19:20:00',
    'Gasto adicional salud 2025-04',
    '2025-04-22 19:20:00',
    '2025-04-22 19:20:00'
),
(
    '30000000-0000-0000-0000-000000000278',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    221.37,
    '2025-05-20 11:04:00',
    'Gasto mensual transporte 2025-05',
    '2025-05-20 11:04:00',
    '2025-05-20 11:04:00'
),
(
    '30000000-0000-0000-0000-000000000279',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    41.75,
    '2025-05-23 19:27:00',
    'Gasto adicional educacion 2025-05',
    '2025-05-23 19:27:00',
    '2025-05-23 19:27:00'
),
(
    '30000000-0000-0000-0000-000000000280',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    228.74,
    '2025-06-21 11:11:00',
    'Gasto mensual servicios 2025-06',
    '2025-06-21 11:11:00',
    '2025-06-21 11:11:00'
),
(
    '30000000-0000-0000-0000-000000000281',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    235.00,
    '2025-07-22 11:18:00',
    'Gasto mensual salud 2025-07',
    '2025-07-22 11:18:00',
    '2025-07-22 11:18:00'
),
(
    '30000000-0000-0000-0000-000000000282',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    242.37,
    '2025-08-23 11:25:00',
    'Gasto mensual educacion 2025-08',
    '2025-08-23 11:25:00',
    '2025-08-23 11:25:00'
),
(
    '30000000-0000-0000-0000-000000000283',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    29.74,
    '2025-09-24 11:32:00',
    'Gasto mensual entretenimiento 2025-09',
    '2025-09-24 11:32:00',
    '2025-09-24 11:32:00'
),
(
    '30000000-0000-0000-0000-000000000284',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    61.75,
    '2025-09-27 19:55:00',
    'Gasto adicional servicios 2025-09',
    '2025-09-27 19:55:00',
    '2025-09-27 19:55:00'
),
(
    '30000000-0000-0000-0000-000000000285',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    36.00,
    '2025-10-05 11:39:00',
    'Gasto mensual alimentacion 2025-10',
    '2025-10-05 11:39:00',
    '2025-10-05 11:39:00'
),
(
    '30000000-0000-0000-0000-000000000286',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    66.75,
    '2025-10-08 19:02:00',
    'Gasto adicional salud 2025-10',
    '2025-10-08 19:02:00',
    '2025-10-08 19:02:00'
),
(
    '30000000-0000-0000-0000-000000000287',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    43.37,
    '2025-11-06 11:46:00',
    'Gasto mensual transporte 2025-11',
    '2025-11-06 11:46:00',
    '2025-11-06 11:46:00'
),
(
    '30000000-0000-0000-0000-000000000288',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    50.74,
    '2025-12-07 11:53:00',
    'Gasto mensual servicios 2025-12',
    '2025-12-07 11:53:00',
    '2025-12-07 11:53:00'
),
(
    '30000000-0000-0000-0000-000000000289',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    90.00,
    '2021-01-09 12:00:00',
    'Gasto mensual educacion 2021-01',
    '2021-01-09 12:00:00',
    '2021-01-09 12:00:00'
),
(
    '30000000-0000-0000-0000-000000000290',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    75.00,
    '2021-01-12 19:23:00',
    'Gasto adicional transporte 2021-01',
    '2021-01-12 19:23:00',
    '2021-01-12 19:23:00'
),
(
    '30000000-0000-0000-0000-000000000291',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    97.37,
    '2021-02-10 12:07:00',
    'Gasto mensual entretenimiento 2021-02',
    '2021-02-10 12:07:00',
    '2021-02-10 12:07:00'
),
(
    '30000000-0000-0000-0000-000000000292',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    104.74,
    '2021-03-11 12:14:00',
    'Gasto mensual alimentacion 2021-03',
    '2021-03-11 12:14:00',
    '2021-03-11 12:14:00'
),
(
    '30000000-0000-0000-0000-000000000293',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    111.00,
    '2021-04-12 12:21:00',
    'Gasto mensual transporte 2021-04',
    '2021-04-12 12:21:00',
    '2021-04-12 12:21:00'
),
(
    '30000000-0000-0000-0000-000000000294',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    118.37,
    '2021-05-13 12:28:00',
    'Gasto mensual servicios 2021-05',
    '2021-05-13 12:28:00',
    '2021-05-13 12:28:00'
),
(
    '30000000-0000-0000-0000-000000000295',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    125.74,
    '2021-06-14 12:35:00',
    'Gasto mensual salud 2021-06',
    '2021-06-14 12:35:00',
    '2021-06-14 12:35:00'
),
(
    '30000000-0000-0000-0000-000000000296',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    100.00,
    '2021-06-17 19:58:00',
    'Gasto adicional alimentacion 2021-06',
    '2021-06-17 19:58:00',
    '2021-06-17 19:58:00'
),
(
    '30000000-0000-0000-0000-000000000297',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    132.00,
    '2021-07-15 12:42:00',
    'Gasto mensual educacion 2021-07',
    '2021-07-15 12:42:00',
    '2021-07-15 12:42:00'
),
(
    '30000000-0000-0000-0000-000000000298',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    105.00,
    '2021-07-18 19:05:00',
    'Gasto adicional transporte 2021-07',
    '2021-07-18 19:05:00',
    '2021-07-18 19:05:00'
),
(
    '30000000-0000-0000-0000-000000000299',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    139.37,
    '2021-08-16 12:49:00',
    'Gasto mensual entretenimiento 2021-08',
    '2021-08-16 12:49:00',
    '2021-08-16 12:49:00'
),
(
    '30000000-0000-0000-0000-000000000300',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    146.74,
    '2021-09-17 12:56:00',
    'Gasto mensual alimentacion 2021-09',
    '2021-09-17 12:56:00',
    '2021-09-17 12:56:00'
),
(
    '30000000-0000-0000-0000-000000000301',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    153.00,
    '2021-10-18 12:03:00',
    'Gasto mensual transporte 2021-10',
    '2021-10-18 12:03:00',
    '2021-10-18 12:03:00'
),
(
    '30000000-0000-0000-0000-000000000302',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    160.37,
    '2021-11-19 12:10:00',
    'Gasto mensual servicios 2021-11',
    '2021-11-19 12:10:00',
    '2021-11-19 12:10:00'
),
(
    '30000000-0000-0000-0000-000000000303',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    167.74,
    '2021-12-20 12:17:00',
    'Gasto mensual salud 2021-12',
    '2021-12-20 12:17:00',
    '2021-12-20 12:17:00'
),
(
    '30000000-0000-0000-0000-000000000304',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    35.00,
    '2021-12-23 19:40:00',
    'Gasto adicional alimentacion 2021-12',
    '2021-12-23 19:40:00',
    '2021-12-23 19:40:00'
),
(
    '30000000-0000-0000-0000-000000000305',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    174.00,
    '2022-01-21 12:24:00',
    'Gasto mensual educacion 2022-01',
    '2022-01-21 12:24:00',
    '2022-01-21 12:24:00'
),
(
    '30000000-0000-0000-0000-000000000306',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    181.37,
    '2022-02-22 12:31:00',
    'Gasto mensual entretenimiento 2022-02',
    '2022-02-22 12:31:00',
    '2022-02-22 12:31:00'
),
(
    '30000000-0000-0000-0000-000000000307',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    188.74,
    '2022-03-23 12:38:00',
    'Gasto mensual alimentacion 2022-03',
    '2022-03-23 12:38:00',
    '2022-03-23 12:38:00'
),
(
    '30000000-0000-0000-0000-000000000308',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    195.00,
    '2022-04-24 12:45:00',
    'Gasto mensual transporte 2022-04',
    '2022-04-24 12:45:00',
    '2022-04-24 12:45:00'
),
(
    '30000000-0000-0000-0000-000000000309',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    202.37,
    '2022-05-05 12:52:00',
    'Gasto mensual servicios 2022-05',
    '2022-05-05 12:52:00',
    '2022-05-05 12:52:00'
),
(
    '30000000-0000-0000-0000-000000000310',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    60.00,
    '2022-05-08 19:15:00',
    'Gasto adicional entretenimiento 2022-05',
    '2022-05-08 19:15:00',
    '2022-05-08 19:15:00'
),
(
    '30000000-0000-0000-0000-000000000311',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    209.74,
    '2022-06-06 12:59:00',
    'Gasto mensual salud 2022-06',
    '2022-06-06 12:59:00',
    '2022-06-06 12:59:00'
),
(
    '30000000-0000-0000-0000-000000000312',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    65.00,
    '2022-06-09 19:22:00',
    'Gasto adicional alimentacion 2022-06',
    '2022-06-09 19:22:00',
    '2022-06-09 19:22:00'
),
(
    '30000000-0000-0000-0000-000000000313',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    216.00,
    '2022-07-07 12:06:00',
    'Gasto mensual educacion 2022-07',
    '2022-07-07 12:06:00',
    '2022-07-07 12:06:00'
),
(
    '30000000-0000-0000-0000-000000000314',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    223.37,
    '2022-08-08 12:13:00',
    'Gasto mensual entretenimiento 2022-08',
    '2022-08-08 12:13:00',
    '2022-08-08 12:13:00'
),
(
    '30000000-0000-0000-0000-000000000315',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    230.74,
    '2022-09-09 12:20:00',
    'Gasto mensual alimentacion 2022-09',
    '2022-09-09 12:20:00',
    '2022-09-09 12:20:00'
),
(
    '30000000-0000-0000-0000-000000000316',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    237.00,
    '2022-10-10 12:27:00',
    'Gasto mensual transporte 2022-10',
    '2022-10-10 12:27:00',
    '2022-10-10 12:27:00'
),
(
    '30000000-0000-0000-0000-000000000317',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    244.37,
    '2022-11-11 12:34:00',
    'Gasto mensual servicios 2022-11',
    '2022-11-11 12:34:00',
    '2022-11-11 12:34:00'
),
(
    '30000000-0000-0000-0000-000000000318',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    90.00,
    '2022-11-14 19:57:00',
    'Gasto adicional entretenimiento 2022-11',
    '2022-11-14 19:57:00',
    '2022-11-14 19:57:00'
),
(
    '30000000-0000-0000-0000-000000000319',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    31.74,
    '2022-12-12 12:41:00',
    'Gasto mensual salud 2022-12',
    '2022-12-12 12:41:00',
    '2022-12-12 12:41:00'
),
(
    '30000000-0000-0000-0000-000000000320',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    38.00,
    '2023-01-13 12:48:00',
    'Gasto mensual educacion 2023-01',
    '2023-01-13 12:48:00',
    '2023-01-13 12:48:00'
),
(
    '30000000-0000-0000-0000-000000000321',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    45.37,
    '2023-02-14 12:55:00',
    'Gasto mensual entretenimiento 2023-02',
    '2023-02-14 12:55:00',
    '2023-02-14 12:55:00'
),
(
    '30000000-0000-0000-0000-000000000322',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    52.74,
    '2023-03-15 12:02:00',
    'Gasto mensual alimentacion 2023-03',
    '2023-03-15 12:02:00',
    '2023-03-15 12:02:00'
),
(
    '30000000-0000-0000-0000-000000000323',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    59.00,
    '2023-04-16 12:09:00',
    'Gasto mensual transporte 2023-04',
    '2023-04-16 12:09:00',
    '2023-04-16 12:09:00'
),
(
    '30000000-0000-0000-0000-000000000324',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    20.00,
    '2023-04-19 19:32:00',
    'Gasto adicional educacion 2023-04',
    '2023-04-19 19:32:00',
    '2023-04-19 19:32:00'
),
(
    '30000000-0000-0000-0000-000000000325',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    66.37,
    '2023-05-17 12:16:00',
    'Gasto mensual servicios 2023-05',
    '2023-05-17 12:16:00',
    '2023-05-17 12:16:00'
),
(
    '30000000-0000-0000-0000-000000000326',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    25.00,
    '2023-05-20 19:39:00',
    'Gasto adicional entretenimiento 2023-05',
    '2023-05-20 19:39:00',
    '2023-05-20 19:39:00'
),
(
    '30000000-0000-0000-0000-000000000327',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    73.74,
    '2023-06-18 12:23:00',
    'Gasto mensual salud 2023-06',
    '2023-06-18 12:23:00',
    '2023-06-18 12:23:00'
),
(
    '30000000-0000-0000-0000-000000000328',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    80.00,
    '2023-07-19 12:30:00',
    'Gasto mensual educacion 2023-07',
    '2023-07-19 12:30:00',
    '2023-07-19 12:30:00'
),
(
    '30000000-0000-0000-0000-000000000329',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    87.37,
    '2023-08-20 12:37:00',
    'Gasto mensual entretenimiento 2023-08',
    '2023-08-20 12:37:00',
    '2023-08-20 12:37:00'
),
(
    '30000000-0000-0000-0000-000000000330',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    94.74,
    '2023-09-21 12:44:00',
    'Gasto mensual alimentacion 2023-09',
    '2023-09-21 12:44:00',
    '2023-09-21 12:44:00'
),
(
    '30000000-0000-0000-0000-000000000331',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    45.00,
    '2023-09-24 19:07:00',
    'Gasto adicional salud 2023-09',
    '2023-09-24 19:07:00',
    '2023-09-24 19:07:00'
),
(
    '30000000-0000-0000-0000-000000000332',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    101.00,
    '2023-10-22 12:51:00',
    'Gasto mensual transporte 2023-10',
    '2023-10-22 12:51:00',
    '2023-10-22 12:51:00'
),
(
    '30000000-0000-0000-0000-000000000333',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    50.00,
    '2023-10-25 19:14:00',
    'Gasto adicional educacion 2023-10',
    '2023-10-25 19:14:00',
    '2023-10-25 19:14:00'
),
(
    '30000000-0000-0000-0000-000000000334',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    108.37,
    '2023-11-23 12:58:00',
    'Gasto mensual servicios 2023-11',
    '2023-11-23 12:58:00',
    '2023-11-23 12:58:00'
),
(
    '30000000-0000-0000-0000-000000000335',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    115.74,
    '2023-12-24 12:05:00',
    'Gasto mensual salud 2023-12',
    '2023-12-24 12:05:00',
    '2023-12-24 12:05:00'
),
(
    '30000000-0000-0000-0000-000000000336',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    122.00,
    '2024-01-05 12:12:00',
    'Gasto mensual educacion 2024-01',
    '2024-01-05 12:12:00',
    '2024-01-05 12:12:00'
),
(
    '30000000-0000-0000-0000-000000000337',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    129.37,
    '2024-02-06 12:19:00',
    'Gasto mensual entretenimiento 2024-02',
    '2024-02-06 12:19:00',
    '2024-02-06 12:19:00'
),
(
    '30000000-0000-0000-0000-000000000338',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    136.74,
    '2024-03-07 12:26:00',
    'Gasto mensual alimentacion 2024-03',
    '2024-03-07 12:26:00',
    '2024-03-07 12:26:00'
),
(
    '30000000-0000-0000-0000-000000000339',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    75.00,
    '2024-03-10 19:49:00',
    'Gasto adicional salud 2024-03',
    '2024-03-10 19:49:00',
    '2024-03-10 19:49:00'
),
(
    '30000000-0000-0000-0000-000000000340',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    143.00,
    '2024-04-08 12:33:00',
    'Gasto mensual transporte 2024-04',
    '2024-04-08 12:33:00',
    '2024-04-08 12:33:00'
),
(
    '30000000-0000-0000-0000-000000000341',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    80.00,
    '2024-04-11 19:56:00',
    'Gasto adicional educacion 2024-04',
    '2024-04-11 19:56:00',
    '2024-04-11 19:56:00'
),
(
    '30000000-0000-0000-0000-000000000342',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    150.37,
    '2024-05-09 12:40:00',
    'Gasto mensual servicios 2024-05',
    '2024-05-09 12:40:00',
    '2024-05-09 12:40:00'
),
(
    '30000000-0000-0000-0000-000000000343',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    157.74,
    '2024-06-10 12:47:00',
    'Gasto mensual salud 2024-06',
    '2024-06-10 12:47:00',
    '2024-06-10 12:47:00'
),
(
    '30000000-0000-0000-0000-000000000344',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    164.00,
    '2024-07-11 12:54:00',
    'Gasto mensual educacion 2024-07',
    '2024-07-11 12:54:00',
    '2024-07-11 12:54:00'
),
(
    '30000000-0000-0000-0000-000000000345',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    171.37,
    '2024-08-12 12:01:00',
    'Gasto mensual entretenimiento 2024-08',
    '2024-08-12 12:01:00',
    '2024-08-12 12:01:00'
),
(
    '30000000-0000-0000-0000-000000000346',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    100.00,
    '2024-08-15 19:24:00',
    'Gasto adicional servicios 2024-08',
    '2024-08-15 19:24:00',
    '2024-08-15 19:24:00'
),
(
    '30000000-0000-0000-0000-000000000347',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    178.74,
    '2024-09-13 12:08:00',
    'Gasto mensual alimentacion 2024-09',
    '2024-09-13 12:08:00',
    '2024-09-13 12:08:00'
),
(
    '30000000-0000-0000-0000-000000000348',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    105.00,
    '2024-09-16 19:31:00',
    'Gasto adicional salud 2024-09',
    '2024-09-16 19:31:00',
    '2024-09-16 19:31:00'
),
(
    '30000000-0000-0000-0000-000000000349',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    185.00,
    '2024-10-14 12:15:00',
    'Gasto mensual transporte 2024-10',
    '2024-10-14 12:15:00',
    '2024-10-14 12:15:00'
),
(
    '30000000-0000-0000-0000-000000000350',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    192.37,
    '2024-11-15 12:22:00',
    'Gasto mensual servicios 2024-11',
    '2024-11-15 12:22:00',
    '2024-11-15 12:22:00'
),
(
    '30000000-0000-0000-0000-000000000351',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    199.74,
    '2024-12-16 12:29:00',
    'Gasto mensual salud 2024-12',
    '2024-12-16 12:29:00',
    '2024-12-16 12:29:00'
),
(
    '30000000-0000-0000-0000-000000000352',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    206.00,
    '2025-01-17 12:36:00',
    'Gasto mensual educacion 2025-01',
    '2025-01-17 12:36:00',
    '2025-01-17 12:36:00'
),
(
    '30000000-0000-0000-0000-000000000353',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    213.37,
    '2025-02-18 12:43:00',
    'Gasto mensual entretenimiento 2025-02',
    '2025-02-18 12:43:00',
    '2025-02-18 12:43:00'
),
(
    '30000000-0000-0000-0000-000000000354',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    35.00,
    '2025-02-21 19:06:00',
    'Gasto adicional servicios 2025-02',
    '2025-02-21 19:06:00',
    '2025-02-21 19:06:00'
),
(
    '30000000-0000-0000-0000-000000000355',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    220.74,
    '2025-03-19 12:50:00',
    'Gasto mensual alimentacion 2025-03',
    '2025-03-19 12:50:00',
    '2025-03-19 12:50:00'
),
(
    '30000000-0000-0000-0000-000000000356',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    227.00,
    '2025-04-20 12:57:00',
    'Gasto mensual transporte 2025-04',
    '2025-04-20 12:57:00',
    '2025-04-20 12:57:00'
),
(
    '30000000-0000-0000-0000-000000000357',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    234.37,
    '2025-05-21 12:04:00',
    'Gasto mensual servicios 2025-05',
    '2025-05-21 12:04:00',
    '2025-05-21 12:04:00'
),
(
    '30000000-0000-0000-0000-000000000358',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    241.74,
    '2025-06-22 12:11:00',
    'Gasto mensual salud 2025-06',
    '2025-06-22 12:11:00',
    '2025-06-22 12:11:00'
),
(
    '30000000-0000-0000-0000-000000000359',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    28.00,
    '2025-07-23 12:18:00',
    'Gasto mensual educacion 2025-07',
    '2025-07-23 12:18:00',
    '2025-07-23 12:18:00'
),
(
    '30000000-0000-0000-0000-000000000360',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    60.00,
    '2025-07-26 19:41:00',
    'Gasto adicional transporte 2025-07',
    '2025-07-26 19:41:00',
    '2025-07-26 19:41:00'
),
(
    '30000000-0000-0000-0000-000000000361',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    35.37,
    '2025-08-24 12:25:00',
    'Gasto mensual entretenimiento 2025-08',
    '2025-08-24 12:25:00',
    '2025-08-24 12:25:00'
),
(
    '30000000-0000-0000-0000-000000000362',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    65.00,
    '2025-08-27 19:48:00',
    'Gasto adicional servicios 2025-08',
    '2025-08-27 19:48:00',
    '2025-08-27 19:48:00'
),
(
    '30000000-0000-0000-0000-000000000363',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    42.74,
    '2025-09-05 12:32:00',
    'Gasto mensual alimentacion 2025-09',
    '2025-09-05 12:32:00',
    '2025-09-05 12:32:00'
),
(
    '30000000-0000-0000-0000-000000000364',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    49.00,
    '2025-10-06 12:39:00',
    'Gasto mensual transporte 2025-10',
    '2025-10-06 12:39:00',
    '2025-10-06 12:39:00'
),
(
    '30000000-0000-0000-0000-000000000365',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    56.37,
    '2025-11-07 12:46:00',
    'Gasto mensual servicios 2025-11',
    '2025-11-07 12:46:00',
    '2025-11-07 12:46:00'
),
(
    '30000000-0000-0000-0000-000000000366',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    63.74,
    '2025-12-08 12:53:00',
    'Gasto mensual salud 2025-12',
    '2025-12-08 12:53:00',
    '2025-12-08 12:53:00'
),
(
    '30000000-0000-0000-0000-000000000367',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    103.00,
    '2021-01-10 08:00:00',
    'Gasto mensual entretenimiento 2021-01',
    '2021-01-10 08:00:00',
    '2021-01-10 08:00:00'
),
(
    '30000000-0000-0000-0000-000000000368',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    110.37,
    '2021-02-11 08:07:00',
    'Gasto mensual alimentacion 2021-02',
    '2021-02-11 08:07:00',
    '2021-02-11 08:07:00'
),
(
    '30000000-0000-0000-0000-000000000369',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    117.74,
    '2021-03-12 08:14:00',
    'Gasto mensual transporte 2021-03',
    '2021-03-12 08:14:00',
    '2021-03-12 08:14:00'
),
(
    '30000000-0000-0000-0000-000000000370',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    124.00,
    '2021-04-13 08:21:00',
    'Gasto mensual servicios 2021-04',
    '2021-04-13 08:21:00',
    '2021-04-13 08:21:00'
),
(
    '30000000-0000-0000-0000-000000000371',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    131.37,
    '2021-05-14 08:28:00',
    'Gasto mensual salud 2021-05',
    '2021-05-14 08:28:00',
    '2021-05-14 08:28:00'
),
(
    '30000000-0000-0000-0000-000000000372',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    104.25,
    '2021-05-17 19:51:00',
    'Gasto adicional alimentacion 2021-05',
    '2021-05-17 19:51:00',
    '2021-05-17 19:51:00'
),
(
    '30000000-0000-0000-0000-000000000373',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    138.74,
    '2021-06-15 08:35:00',
    'Gasto mensual educacion 2021-06',
    '2021-06-15 08:35:00',
    '2021-06-15 08:35:00'
),
(
    '30000000-0000-0000-0000-000000000374',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    145.00,
    '2021-07-16 08:42:00',
    'Gasto mensual entretenimiento 2021-07',
    '2021-07-16 08:42:00',
    '2021-07-16 08:42:00'
),
(
    '30000000-0000-0000-0000-000000000375',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    152.37,
    '2021-08-17 08:49:00',
    'Gasto mensual alimentacion 2021-08',
    '2021-08-17 08:49:00',
    '2021-08-17 08:49:00'
),
(
    '30000000-0000-0000-0000-000000000376',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    159.74,
    '2021-09-18 08:56:00',
    'Gasto mensual transporte 2021-09',
    '2021-09-18 08:56:00',
    '2021-09-18 08:56:00'
),
(
    '30000000-0000-0000-0000-000000000377',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    166.00,
    '2021-10-19 08:03:00',
    'Gasto mensual servicios 2021-10',
    '2021-10-19 08:03:00',
    '2021-10-19 08:03:00'
),
(
    '30000000-0000-0000-0000-000000000378',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    34.25,
    '2021-10-22 19:26:00',
    'Gasto adicional entretenimiento 2021-10',
    '2021-10-22 19:26:00',
    '2021-10-22 19:26:00'
),
(
    '30000000-0000-0000-0000-000000000379',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    173.37,
    '2021-11-20 08:10:00',
    'Gasto mensual salud 2021-11',
    '2021-11-20 08:10:00',
    '2021-11-20 08:10:00'
),
(
    '30000000-0000-0000-0000-000000000380',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    180.74,
    '2021-12-21 08:17:00',
    'Gasto mensual educacion 2021-12',
    '2021-12-21 08:17:00',
    '2021-12-21 08:17:00'
),
(
    '30000000-0000-0000-0000-000000000381',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    187.00,
    '2022-01-22 08:24:00',
    'Gasto mensual entretenimiento 2022-01',
    '2022-01-22 08:24:00',
    '2022-01-22 08:24:00'
),
(
    '30000000-0000-0000-0000-000000000382',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    194.37,
    '2022-02-23 08:31:00',
    'Gasto mensual alimentacion 2022-02',
    '2022-02-23 08:31:00',
    '2022-02-23 08:31:00'
),
(
    '30000000-0000-0000-0000-000000000383',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    201.74,
    '2022-03-24 08:38:00',
    'Gasto mensual transporte 2022-03',
    '2022-03-24 08:38:00',
    '2022-03-24 08:38:00'
),
(
    '30000000-0000-0000-0000-000000000384',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    208.00,
    '2022-04-05 08:45:00',
    'Gasto mensual servicios 2022-04',
    '2022-04-05 08:45:00',
    '2022-04-05 08:45:00'
),
(
    '30000000-0000-0000-0000-000000000385',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    215.37,
    '2022-05-06 08:52:00',
    'Gasto mensual salud 2022-05',
    '2022-05-06 08:52:00',
    '2022-05-06 08:52:00'
),
(
    '30000000-0000-0000-0000-000000000386',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    222.74,
    '2022-06-07 08:59:00',
    'Gasto mensual educacion 2022-06',
    '2022-06-07 08:59:00',
    '2022-06-07 08:59:00'
),
(
    '30000000-0000-0000-0000-000000000387',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    229.00,
    '2022-07-08 08:06:00',
    'Gasto mensual entretenimiento 2022-07',
    '2022-07-08 08:06:00',
    '2022-07-08 08:06:00'
),
(
    '30000000-0000-0000-0000-000000000388',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    236.37,
    '2022-08-09 08:13:00',
    'Gasto mensual alimentacion 2022-08',
    '2022-08-09 08:13:00',
    '2022-08-09 08:13:00'
),
(
    '30000000-0000-0000-0000-000000000389',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    243.74,
    '2022-09-10 08:20:00',
    'Gasto mensual transporte 2022-09',
    '2022-09-10 08:20:00',
    '2022-09-10 08:20:00'
),
(
    '30000000-0000-0000-0000-000000000390',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    89.25,
    '2022-09-13 19:43:00',
    'Gasto adicional educacion 2022-09',
    '2022-09-13 19:43:00',
    '2022-09-13 19:43:00'
),
(
    '30000000-0000-0000-0000-000000000391',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    30.00,
    '2022-10-11 08:27:00',
    'Gasto mensual servicios 2022-10',
    '2022-10-11 08:27:00',
    '2022-10-11 08:27:00'
),
(
    '30000000-0000-0000-0000-000000000392',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    37.37,
    '2022-11-12 08:34:00',
    'Gasto mensual salud 2022-11',
    '2022-11-12 08:34:00',
    '2022-11-12 08:34:00'
),
(
    '30000000-0000-0000-0000-000000000393',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    44.74,
    '2022-12-13 08:41:00',
    'Gasto mensual educacion 2022-12',
    '2022-12-13 08:41:00',
    '2022-12-13 08:41:00'
),
(
    '30000000-0000-0000-0000-000000000394',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    51.00,
    '2023-01-14 08:48:00',
    'Gasto mensual entretenimiento 2023-01',
    '2023-01-14 08:48:00',
    '2023-01-14 08:48:00'
),
(
    '30000000-0000-0000-0000-000000000395',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    58.37,
    '2023-02-15 08:55:00',
    'Gasto mensual alimentacion 2023-02',
    '2023-02-15 08:55:00',
    '2023-02-15 08:55:00'
),
(
    '30000000-0000-0000-0000-000000000396',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    19.25,
    '2023-02-18 19:18:00',
    'Gasto adicional salud 2023-02',
    '2023-02-18 19:18:00',
    '2023-02-18 19:18:00'
),
(
    '30000000-0000-0000-0000-000000000397',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    65.74,
    '2023-03-16 08:02:00',
    'Gasto mensual transporte 2023-03',
    '2023-03-16 08:02:00',
    '2023-03-16 08:02:00'
),
(
    '30000000-0000-0000-0000-000000000398',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    72.00,
    '2023-04-17 08:09:00',
    'Gasto mensual servicios 2023-04',
    '2023-04-17 08:09:00',
    '2023-04-17 08:09:00'
),
(
    '30000000-0000-0000-0000-000000000399',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    79.37,
    '2023-05-18 08:16:00',
    'Gasto mensual salud 2023-05',
    '2023-05-18 08:16:00',
    '2023-05-18 08:16:00'
),
(
    '30000000-0000-0000-0000-000000000400',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    86.74,
    '2023-06-19 08:23:00',
    'Gasto mensual educacion 2023-06',
    '2023-06-19 08:23:00',
    '2023-06-19 08:23:00'
),
(
    '30000000-0000-0000-0000-000000000401',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    93.00,
    '2023-07-20 08:30:00',
    'Gasto mensual entretenimiento 2023-07',
    '2023-07-20 08:30:00',
    '2023-07-20 08:30:00'
),
(
    '30000000-0000-0000-0000-000000000402',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    100.37,
    '2023-08-21 08:37:00',
    'Gasto mensual alimentacion 2023-08',
    '2023-08-21 08:37:00',
    '2023-08-21 08:37:00'
),
(
    '30000000-0000-0000-0000-000000000403',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    49.25,
    '2023-08-24 19:00:00',
    'Gasto adicional salud 2023-08',
    '2023-08-24 19:00:00',
    '2023-08-24 19:00:00'
),
(
    '30000000-0000-0000-0000-000000000404',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    107.74,
    '2023-09-22 08:44:00',
    'Gasto mensual transporte 2023-09',
    '2023-09-22 08:44:00',
    '2023-09-22 08:44:00'
),
(
    '30000000-0000-0000-0000-000000000405',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    114.00,
    '2023-10-23 08:51:00',
    'Gasto mensual servicios 2023-10',
    '2023-10-23 08:51:00',
    '2023-10-23 08:51:00'
),
(
    '30000000-0000-0000-0000-000000000406',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    121.37,
    '2023-11-24 08:58:00',
    'Gasto mensual salud 2023-11',
    '2023-11-24 08:58:00',
    '2023-11-24 08:58:00'
),
(
    '30000000-0000-0000-0000-000000000407',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    128.74,
    '2023-12-05 08:05:00',
    'Gasto mensual educacion 2023-12',
    '2023-12-05 08:05:00',
    '2023-12-05 08:05:00'
),
(
    '30000000-0000-0000-0000-000000000408',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    135.00,
    '2024-01-06 08:12:00',
    'Gasto mensual entretenimiento 2024-01',
    '2024-01-06 08:12:00',
    '2024-01-06 08:12:00'
),
(
    '30000000-0000-0000-0000-000000000409',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    74.25,
    '2024-01-09 19:35:00',
    'Gasto adicional servicios 2024-01',
    '2024-01-09 19:35:00',
    '2024-01-09 19:35:00'
),
(
    '30000000-0000-0000-0000-000000000410',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    142.37,
    '2024-02-07 08:19:00',
    'Gasto mensual alimentacion 2024-02',
    '2024-02-07 08:19:00',
    '2024-02-07 08:19:00'
),
(
    '30000000-0000-0000-0000-000000000411',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    149.74,
    '2024-03-08 08:26:00',
    'Gasto mensual transporte 2024-03',
    '2024-03-08 08:26:00',
    '2024-03-08 08:26:00'
),
(
    '30000000-0000-0000-0000-000000000412',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    156.00,
    '2024-04-09 08:33:00',
    'Gasto mensual servicios 2024-04',
    '2024-04-09 08:33:00',
    '2024-04-09 08:33:00'
),
(
    '30000000-0000-0000-0000-000000000413',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    163.37,
    '2024-05-10 08:40:00',
    'Gasto mensual salud 2024-05',
    '2024-05-10 08:40:00',
    '2024-05-10 08:40:00'
),
(
    '30000000-0000-0000-0000-000000000414',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    170.74,
    '2024-06-11 08:47:00',
    'Gasto mensual educacion 2024-06',
    '2024-06-11 08:47:00',
    '2024-06-11 08:47:00'
),
(
    '30000000-0000-0000-0000-000000000415',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    177.00,
    '2024-07-12 08:54:00',
    'Gasto mensual entretenimiento 2024-07',
    '2024-07-12 08:54:00',
    '2024-07-12 08:54:00'
),
(
    '30000000-0000-0000-0000-000000000416',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    104.25,
    '2024-07-15 19:17:00',
    'Gasto adicional servicios 2024-07',
    '2024-07-15 19:17:00',
    '2024-07-15 19:17:00'
),
(
    '30000000-0000-0000-0000-000000000417',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    184.37,
    '2024-08-13 08:01:00',
    'Gasto mensual alimentacion 2024-08',
    '2024-08-13 08:01:00',
    '2024-08-13 08:01:00'
),
(
    '30000000-0000-0000-0000-000000000418',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    191.74,
    '2024-09-14 08:08:00',
    'Gasto mensual transporte 2024-09',
    '2024-09-14 08:08:00',
    '2024-09-14 08:08:00'
),
(
    '30000000-0000-0000-0000-000000000419',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    198.00,
    '2024-10-15 08:15:00',
    'Gasto mensual servicios 2024-10',
    '2024-10-15 08:15:00',
    '2024-10-15 08:15:00'
),
(
    '30000000-0000-0000-0000-000000000420',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    205.37,
    '2024-11-16 08:22:00',
    'Gasto mensual salud 2024-11',
    '2024-11-16 08:22:00',
    '2024-11-16 08:22:00'
),
(
    '30000000-0000-0000-0000-000000000421',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    212.74,
    '2024-12-17 08:29:00',
    'Gasto mensual educacion 2024-12',
    '2024-12-17 08:29:00',
    '2024-12-17 08:29:00'
),
(
    '30000000-0000-0000-0000-000000000422',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    34.25,
    '2024-12-20 19:52:00',
    'Gasto adicional transporte 2024-12',
    '2024-12-20 19:52:00',
    '2024-12-20 19:52:00'
),
(
    '30000000-0000-0000-0000-000000000423',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    219.00,
    '2025-01-18 08:36:00',
    'Gasto mensual entretenimiento 2025-01',
    '2025-01-18 08:36:00',
    '2025-01-18 08:36:00'
),
(
    '30000000-0000-0000-0000-000000000424',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    226.37,
    '2025-02-19 08:43:00',
    'Gasto mensual alimentacion 2025-02',
    '2025-02-19 08:43:00',
    '2025-02-19 08:43:00'
),
(
    '30000000-0000-0000-0000-000000000425',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    233.74,
    '2025-03-20 08:50:00',
    'Gasto mensual transporte 2025-03',
    '2025-03-20 08:50:00',
    '2025-03-20 08:50:00'
),
(
    '30000000-0000-0000-0000-000000000426',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    240.00,
    '2025-04-21 08:57:00',
    'Gasto mensual servicios 2025-04',
    '2025-04-21 08:57:00',
    '2025-04-21 08:57:00'
),
(
    '30000000-0000-0000-0000-000000000427',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    27.37,
    '2025-05-22 08:04:00',
    'Gasto mensual salud 2025-05',
    '2025-05-22 08:04:00',
    '2025-05-22 08:04:00'
),
(
    '30000000-0000-0000-0000-000000000428',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    34.74,
    '2025-06-23 08:11:00',
    'Gasto mensual educacion 2025-06',
    '2025-06-23 08:11:00',
    '2025-06-23 08:11:00'
),
(
    '30000000-0000-0000-0000-000000000429',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    64.25,
    '2025-06-26 19:34:00',
    'Gasto adicional transporte 2025-06',
    '2025-06-26 19:34:00',
    '2025-06-26 19:34:00'
),
(
    '30000000-0000-0000-0000-000000000430',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    41.00,
    '2025-07-24 08:18:00',
    'Gasto mensual entretenimiento 2025-07',
    '2025-07-24 08:18:00',
    '2025-07-24 08:18:00'
),
(
    '30000000-0000-0000-0000-000000000431',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    48.37,
    '2025-08-05 08:25:00',
    'Gasto mensual alimentacion 2025-08',
    '2025-08-05 08:25:00',
    '2025-08-05 08:25:00'
),
(
    '30000000-0000-0000-0000-000000000432',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    55.74,
    '2025-09-06 08:32:00',
    'Gasto mensual transporte 2025-09',
    '2025-09-06 08:32:00',
    '2025-09-06 08:32:00'
),
(
    '30000000-0000-0000-0000-000000000433',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    62.00,
    '2025-10-07 08:39:00',
    'Gasto mensual servicios 2025-10',
    '2025-10-07 08:39:00',
    '2025-10-07 08:39:00'
),
(
    '30000000-0000-0000-0000-000000000434',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Salud'),
    69.37,
    '2025-11-08 08:46:00',
    'Gasto mensual salud 2025-11',
    '2025-11-08 08:46:00',
    '2025-11-08 08:46:00'
),
(
    '30000000-0000-0000-0000-000000000435',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    89.25,
    '2025-11-11 19:09:00',
    'Gasto adicional alimentacion 2025-11',
    '2025-11-11 19:09:00',
    '2025-11-11 19:09:00'
),
(
    '30000000-0000-0000-0000-000000000436',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    76.74,
    '2025-12-09 08:53:00',
    'Gasto mensual educacion 2025-12',
    '2025-12-09 08:53:00',
    '2025-12-09 08:53:00'
),
(
    '30000000-0000-0000-0000-000000000437',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    116.00,
    '2021-01-11 09:00:00',
    'Gasto mensual alimentacion 2021-01',
    '2021-01-11 09:00:00',
    '2021-01-11 09:00:00'
),
(
    '30000000-0000-0000-0000-000000000438',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    123.37,
    '2021-02-12 09:07:00',
    'Gasto mensual transporte 2021-02',
    '2021-02-12 09:07:00',
    '2021-02-12 09:07:00'
),
(
    '30000000-0000-0000-0000-000000000439',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    130.74,
    '2021-03-13 09:14:00',
    'Gasto mensual servicios 2021-03',
    '2021-03-13 09:14:00',
    '2021-03-13 09:14:00'
),
(
    '30000000-0000-0000-0000-000000000440',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    103.50,
    '2021-03-16 19:37:00',
    'Gasto adicional entretenimiento 2021-03',
    '2021-03-16 19:37:00',
    '2021-03-16 19:37:00'
),
(
    '30000000-0000-0000-0000-000000000441',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    137.00,
    '2021-04-14 09:21:00',
    'Gasto mensual salud 2021-04',
    '2021-04-14 09:21:00',
    '2021-04-14 09:21:00'
),
(
    '30000000-0000-0000-0000-000000000442',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    13.50,
    '2021-04-17 19:44:00',
    'Gasto adicional alimentacion 2021-04',
    '2021-04-17 19:44:00',
    '2021-04-17 19:44:00'
),
(
    '30000000-0000-0000-0000-000000000443',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    144.37,
    '2021-05-15 09:28:00',
    'Gasto mensual educacion 2021-05',
    '2021-05-15 09:28:00',
    '2021-05-15 09:28:00'
),
(
    '30000000-0000-0000-0000-000000000444',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    18.50,
    '2021-05-18 19:51:00',
    'Gasto adicional transporte 2021-05',
    '2021-05-18 19:51:00',
    '2021-05-18 19:51:00'
),
(
    '30000000-0000-0000-0000-000000000445',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    151.74,
    '2021-06-16 09:35:00',
    'Gasto mensual entretenimiento 2021-06',
    '2021-06-16 09:35:00',
    '2021-06-16 09:35:00'
),
(
    '30000000-0000-0000-0000-000000000446',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    158.00,
    '2021-07-17 09:42:00',
    'Gasto mensual alimentacion 2021-07',
    '2021-07-17 09:42:00',
    '2021-07-17 09:42:00'
),
(
    '30000000-0000-0000-0000-000000000447',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    165.37,
    '2021-08-18 09:49:00',
    'Gasto mensual transporte 2021-08',
    '2021-08-18 09:49:00',
    '2021-08-18 09:49:00'
),
(
    '30000000-0000-0000-0000-000000000448',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    172.74,
    '2021-09-19 09:56:00',
    'Gasto mensual servicios 2021-09',
    '2021-09-19 09:56:00',
    '2021-09-19 09:56:00'
),
(
    '30000000-0000-0000-0000-000000000449',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    38.50,
    '2021-09-22 19:19:00',
    'Gasto adicional entretenimiento 2021-09',
    '2021-09-22 19:19:00',
    '2021-09-22 19:19:00'
),
(
    '30000000-0000-0000-0000-000000000450',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    179.00,
    '2021-10-20 09:03:00',
    'Gasto mensual salud 2021-10',
    '2021-10-20 09:03:00',
    '2021-10-20 09:03:00'
),
(
    '30000000-0000-0000-0000-000000000451',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    43.50,
    '2021-10-23 19:26:00',
    'Gasto adicional alimentacion 2021-10',
    '2021-10-23 19:26:00',
    '2021-10-23 19:26:00'
),
(
    '30000000-0000-0000-0000-000000000452',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    186.37,
    '2021-11-21 09:10:00',
    'Gasto mensual educacion 2021-11',
    '2021-11-21 09:10:00',
    '2021-11-21 09:10:00'
),
(
    '30000000-0000-0000-0000-000000000453',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    193.74,
    '2021-12-22 09:17:00',
    'Gasto mensual entretenimiento 2021-12',
    '2021-12-22 09:17:00',
    '2021-12-22 09:17:00'
),
(
    '30000000-0000-0000-0000-000000000454',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    200.00,
    '2022-01-23 09:24:00',
    'Gasto mensual alimentacion 2022-01',
    '2022-01-23 09:24:00',
    '2022-01-23 09:24:00'
),
(
    '30000000-0000-0000-0000-000000000455',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    207.37,
    '2022-02-24 09:31:00',
    'Gasto mensual transporte 2022-02',
    '2022-02-24 09:31:00',
    '2022-02-24 09:31:00'
),
(
    '30000000-0000-0000-0000-000000000456',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    63.50,
    '2022-02-27 19:54:00',
    'Gasto adicional educacion 2022-02',
    '2022-02-27 19:54:00',
    '2022-02-27 19:54:00'
),
(
    '30000000-0000-0000-0000-000000000457',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    214.74,
    '2022-03-05 09:38:00',
    'Gasto mensual servicios 2022-03',
    '2022-03-05 09:38:00',
    '2022-03-05 09:38:00'
),
(
    '30000000-0000-0000-0000-000000000458',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    68.50,
    '2022-03-08 19:01:00',
    'Gasto adicional entretenimiento 2022-03',
    '2022-03-08 19:01:00',
    '2022-03-08 19:01:00'
),
(
    '30000000-0000-0000-0000-000000000459',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    221.00,
    '2022-04-06 09:45:00',
    'Gasto mensual salud 2022-04',
    '2022-04-06 09:45:00',
    '2022-04-06 09:45:00'
),
(
    '30000000-0000-0000-0000-000000000460',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    73.50,
    '2022-04-09 19:08:00',
    'Gasto adicional alimentacion 2022-04',
    '2022-04-09 19:08:00',
    '2022-04-09 19:08:00'
),
(
    '30000000-0000-0000-0000-000000000461',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    228.37,
    '2022-05-07 09:52:00',
    'Gasto mensual educacion 2022-05',
    '2022-05-07 09:52:00',
    '2022-05-07 09:52:00'
),
(
    '30000000-0000-0000-0000-000000000462',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    235.74,
    '2022-06-08 09:59:00',
    'Gasto mensual entretenimiento 2022-06',
    '2022-06-08 09:59:00',
    '2022-06-08 09:59:00'
),
(
    '30000000-0000-0000-0000-000000000463',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    242.00,
    '2022-07-09 09:06:00',
    'Gasto mensual alimentacion 2022-07',
    '2022-07-09 09:06:00',
    '2022-07-09 09:06:00'
),
(
    '30000000-0000-0000-0000-000000000464',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    88.50,
    '2022-07-12 19:29:00',
    'Gasto adicional salud 2022-07',
    '2022-07-12 19:29:00',
    '2022-07-12 19:29:00'
),
(
    '30000000-0000-0000-0000-000000000465',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    29.37,
    '2022-08-10 09:13:00',
    'Gasto mensual transporte 2022-08',
    '2022-08-10 09:13:00',
    '2022-08-10 09:13:00'
),
(
    '30000000-0000-0000-0000-000000000466',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    93.50,
    '2022-08-13 19:36:00',
    'Gasto adicional educacion 2022-08',
    '2022-08-13 19:36:00',
    '2022-08-13 19:36:00'
),
(
    '30000000-0000-0000-0000-000000000467',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    36.74,
    '2022-09-11 09:20:00',
    'Gasto mensual servicios 2022-09',
    '2022-09-11 09:20:00',
    '2022-09-11 09:20:00'
),
(
    '30000000-0000-0000-0000-000000000468',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    98.50,
    '2022-09-14 19:43:00',
    'Gasto adicional entretenimiento 2022-09',
    '2022-09-14 19:43:00',
    '2022-09-14 19:43:00'
),
(
    '30000000-0000-0000-0000-000000000469',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    43.00,
    '2022-10-12 09:27:00',
    'Gasto mensual salud 2022-10',
    '2022-10-12 09:27:00',
    '2022-10-12 09:27:00'
),
(
    '30000000-0000-0000-0000-000000000470',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    50.37,
    '2022-11-13 09:34:00',
    'Gasto mensual educacion 2022-11',
    '2022-11-13 09:34:00',
    '2022-11-13 09:34:00'
),
(
    '30000000-0000-0000-0000-000000000471',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    57.74,
    '2022-12-14 09:41:00',
    'Gasto mensual entretenimiento 2022-12',
    '2022-12-14 09:41:00',
    '2022-12-14 09:41:00'
),
(
    '30000000-0000-0000-0000-000000000472',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    64.00,
    '2023-01-15 09:48:00',
    'Gasto mensual alimentacion 2023-01',
    '2023-01-15 09:48:00',
    '2023-01-15 09:48:00'
),
(
    '30000000-0000-0000-0000-000000000473',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    23.50,
    '2023-01-18 19:11:00',
    'Gasto adicional salud 2023-01',
    '2023-01-18 19:11:00',
    '2023-01-18 19:11:00'
),
(
    '30000000-0000-0000-0000-000000000474',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    71.37,
    '2023-02-16 09:55:00',
    'Gasto mensual transporte 2023-02',
    '2023-02-16 09:55:00',
    '2023-02-16 09:55:00'
),
(
    '30000000-0000-0000-0000-000000000475',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    28.50,
    '2023-02-19 19:18:00',
    'Gasto adicional educacion 2023-02',
    '2023-02-19 19:18:00',
    '2023-02-19 19:18:00'
),
(
    '30000000-0000-0000-0000-000000000476',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    78.74,
    '2023-03-17 09:02:00',
    'Gasto mensual servicios 2023-03',
    '2023-03-17 09:02:00',
    '2023-03-17 09:02:00'
),
(
    '30000000-0000-0000-0000-000000000477',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    33.50,
    '2023-03-20 19:25:00',
    'Gasto adicional entretenimiento 2023-03',
    '2023-03-20 19:25:00',
    '2023-03-20 19:25:00'
),
(
    '30000000-0000-0000-0000-000000000478',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    85.00,
    '2023-04-18 09:09:00',
    'Gasto mensual salud 2023-04',
    '2023-04-18 09:09:00',
    '2023-04-18 09:09:00'
),
(
    '30000000-0000-0000-0000-000000000479',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    92.37,
    '2023-05-19 09:16:00',
    'Gasto mensual educacion 2023-05',
    '2023-05-19 09:16:00',
    '2023-05-19 09:16:00'
),
(
    '30000000-0000-0000-0000-000000000480',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    99.74,
    '2023-06-20 09:23:00',
    'Gasto mensual entretenimiento 2023-06',
    '2023-06-20 09:23:00',
    '2023-06-20 09:23:00'
),
(
    '30000000-0000-0000-0000-000000000481',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    48.50,
    '2023-06-23 19:46:00',
    'Gasto adicional servicios 2023-06',
    '2023-06-23 19:46:00',
    '2023-06-23 19:46:00'
),
(
    '30000000-0000-0000-0000-000000000482',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    106.00,
    '2023-07-21 09:30:00',
    'Gasto mensual alimentacion 2023-07',
    '2023-07-21 09:30:00',
    '2023-07-21 09:30:00'
),
(
    '30000000-0000-0000-0000-000000000483',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    53.50,
    '2023-07-24 19:53:00',
    'Gasto adicional salud 2023-07',
    '2023-07-24 19:53:00',
    '2023-07-24 19:53:00'
),
(
    '30000000-0000-0000-0000-000000000484',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    113.37,
    '2023-08-22 09:37:00',
    'Gasto mensual transporte 2023-08',
    '2023-08-22 09:37:00',
    '2023-08-22 09:37:00'
),
(
    '30000000-0000-0000-0000-000000000485',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    58.50,
    '2023-08-25 19:00:00',
    'Gasto adicional educacion 2023-08',
    '2023-08-25 19:00:00',
    '2023-08-25 19:00:00'
),
(
    '30000000-0000-0000-0000-000000000486',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    120.74,
    '2023-09-23 09:44:00',
    'Gasto mensual servicios 2023-09',
    '2023-09-23 09:44:00',
    '2023-09-23 09:44:00'
),
(
    '30000000-0000-0000-0000-000000000487',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    127.00,
    '2023-10-24 09:51:00',
    'Gasto mensual salud 2023-10',
    '2023-10-24 09:51:00',
    '2023-10-24 09:51:00'
),
(
    '30000000-0000-0000-0000-000000000488',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    134.37,
    '2023-11-05 09:58:00',
    'Gasto mensual educacion 2023-11',
    '2023-11-05 09:58:00',
    '2023-11-05 09:58:00'
),
(
    '30000000-0000-0000-0000-000000000489',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    141.74,
    '2023-12-06 09:05:00',
    'Gasto mensual entretenimiento 2023-12',
    '2023-12-06 09:05:00',
    '2023-12-06 09:05:00'
),
(
    '30000000-0000-0000-0000-000000000490',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    78.50,
    '2023-12-09 19:28:00',
    'Gasto adicional servicios 2023-12',
    '2023-12-09 19:28:00',
    '2023-12-09 19:28:00'
),
(
    '30000000-0000-0000-0000-000000000491',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    148.00,
    '2024-01-07 09:12:00',
    'Gasto mensual alimentacion 2024-01',
    '2024-01-07 09:12:00',
    '2024-01-07 09:12:00'
),
(
    '30000000-0000-0000-0000-000000000492',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    83.50,
    '2024-01-10 19:35:00',
    'Gasto adicional salud 2024-01',
    '2024-01-10 19:35:00',
    '2024-01-10 19:35:00'
),
(
    '30000000-0000-0000-0000-000000000493',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    155.37,
    '2024-02-08 09:19:00',
    'Gasto mensual transporte 2024-02',
    '2024-02-08 09:19:00',
    '2024-02-08 09:19:00'
),
(
    '30000000-0000-0000-0000-000000000494',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    88.50,
    '2024-02-11 19:42:00',
    'Gasto adicional educacion 2024-02',
    '2024-02-11 19:42:00',
    '2024-02-11 19:42:00'
),
(
    '30000000-0000-0000-0000-000000000495',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    162.74,
    '2024-03-09 09:26:00',
    'Gasto mensual servicios 2024-03',
    '2024-03-09 09:26:00',
    '2024-03-09 09:26:00'
),
(
    '30000000-0000-0000-0000-000000000496',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    169.00,
    '2024-04-10 09:33:00',
    'Gasto mensual salud 2024-04',
    '2024-04-10 09:33:00',
    '2024-04-10 09:33:00'
),
(
    '30000000-0000-0000-0000-000000000497',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    176.37,
    '2024-05-11 09:40:00',
    'Gasto mensual educacion 2024-05',
    '2024-05-11 09:40:00',
    '2024-05-11 09:40:00'
),
(
    '30000000-0000-0000-0000-000000000498',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    103.50,
    '2024-05-14 19:03:00',
    'Gasto adicional transporte 2024-05',
    '2024-05-14 19:03:00',
    '2024-05-14 19:03:00'
),
(
    '30000000-0000-0000-0000-000000000499',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    183.74,
    '2024-06-12 09:47:00',
    'Gasto mensual entretenimiento 2024-06',
    '2024-06-12 09:47:00',
    '2024-06-12 09:47:00'
),
(
    '30000000-0000-0000-0000-000000000500',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    13.50,
    '2024-06-15 19:10:00',
    'Gasto adicional servicios 2024-06',
    '2024-06-15 19:10:00',
    '2024-06-15 19:10:00'
),
(
    '30000000-0000-0000-0000-000000000501',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    190.00,
    '2024-07-13 09:54:00',
    'Gasto mensual alimentacion 2024-07',
    '2024-07-13 09:54:00',
    '2024-07-13 09:54:00'
),
(
    '30000000-0000-0000-0000-000000000502',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    18.50,
    '2024-07-16 19:17:00',
    'Gasto adicional salud 2024-07',
    '2024-07-16 19:17:00',
    '2024-07-16 19:17:00'
),
(
    '30000000-0000-0000-0000-000000000503',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    197.37,
    '2024-08-14 09:01:00',
    'Gasto mensual transporte 2024-08',
    '2024-08-14 09:01:00',
    '2024-08-14 09:01:00'
),
(
    '30000000-0000-0000-0000-000000000504',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    204.74,
    '2024-09-15 09:08:00',
    'Gasto mensual servicios 2024-09',
    '2024-09-15 09:08:00',
    '2024-09-15 09:08:00'
),
(
    '30000000-0000-0000-0000-000000000505',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    211.00,
    '2024-10-16 09:15:00',
    'Gasto mensual salud 2024-10',
    '2024-10-16 09:15:00',
    '2024-10-16 09:15:00'
),
(
    '30000000-0000-0000-0000-000000000506',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    218.37,
    '2024-11-17 09:22:00',
    'Gasto mensual educacion 2024-11',
    '2024-11-17 09:22:00',
    '2024-11-17 09:22:00'
),
(
    '30000000-0000-0000-0000-000000000507',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    38.50,
    '2024-11-20 19:45:00',
    'Gasto adicional transporte 2024-11',
    '2024-11-20 19:45:00',
    '2024-11-20 19:45:00'
),
(
    '30000000-0000-0000-0000-000000000508',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    225.74,
    '2024-12-18 09:29:00',
    'Gasto mensual entretenimiento 2024-12',
    '2024-12-18 09:29:00',
    '2024-12-18 09:29:00'
),
(
    '30000000-0000-0000-0000-000000000509',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    43.50,
    '2024-12-21 19:52:00',
    'Gasto adicional servicios 2024-12',
    '2024-12-21 19:52:00',
    '2024-12-21 19:52:00'
),
(
    '30000000-0000-0000-0000-000000000510',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    232.00,
    '2025-01-19 09:36:00',
    'Gasto mensual alimentacion 2025-01',
    '2025-01-19 09:36:00',
    '2025-01-19 09:36:00'
),
(
    '30000000-0000-0000-0000-000000000511',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    239.37,
    '2025-02-20 09:43:00',
    'Gasto mensual transporte 2025-02',
    '2025-02-20 09:43:00',
    '2025-02-20 09:43:00'
),
(
    '30000000-0000-0000-0000-000000000512',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    26.74,
    '2025-03-21 09:50:00',
    'Gasto mensual servicios 2025-03',
    '2025-03-21 09:50:00',
    '2025-03-21 09:50:00'
),
(
    '30000000-0000-0000-0000-000000000513',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    33.00,
    '2025-04-22 09:57:00',
    'Gasto mensual salud 2025-04',
    '2025-04-22 09:57:00',
    '2025-04-22 09:57:00'
),
(
    '30000000-0000-0000-0000-000000000514',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    63.50,
    '2025-04-25 19:20:00',
    'Gasto adicional alimentacion 2025-04',
    '2025-04-25 19:20:00',
    '2025-04-25 19:20:00'
),
(
    '30000000-0000-0000-0000-000000000515',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    40.37,
    '2025-05-23 09:04:00',
    'Gasto mensual educacion 2025-05',
    '2025-05-23 09:04:00',
    '2025-05-23 09:04:00'
),
(
    '30000000-0000-0000-0000-000000000516',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    68.50,
    '2025-05-26 19:27:00',
    'Gasto adicional transporte 2025-05',
    '2025-05-26 19:27:00',
    '2025-05-26 19:27:00'
),
(
    '30000000-0000-0000-0000-000000000517',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    47.74,
    '2025-06-24 09:11:00',
    'Gasto mensual entretenimiento 2025-06',
    '2025-06-24 09:11:00',
    '2025-06-24 09:11:00'
),
(
    '30000000-0000-0000-0000-000000000518',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    73.50,
    '2025-06-27 19:34:00',
    'Gasto adicional servicios 2025-06',
    '2025-06-27 19:34:00',
    '2025-06-27 19:34:00'
),
(
    '30000000-0000-0000-0000-000000000519',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    54.00,
    '2025-07-05 09:18:00',
    'Gasto mensual alimentacion 2025-07',
    '2025-07-05 09:18:00',
    '2025-07-05 09:18:00'
),
(
    '30000000-0000-0000-0000-000000000520',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    61.37,
    '2025-08-06 09:25:00',
    'Gasto mensual transporte 2025-08',
    '2025-08-06 09:25:00',
    '2025-08-06 09:25:00'
),
(
    '30000000-0000-0000-0000-000000000521',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    68.74,
    '2025-09-07 09:32:00',
    'Gasto mensual servicios 2025-09',
    '2025-09-07 09:32:00',
    '2025-09-07 09:32:00'
),
(
    '30000000-0000-0000-0000-000000000522',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    75.00,
    '2025-10-08 09:39:00',
    'Gasto mensual salud 2025-10',
    '2025-10-08 09:39:00',
    '2025-10-08 09:39:00'
),
(
    '30000000-0000-0000-0000-000000000523',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    93.50,
    '2025-10-11 19:02:00',
    'Gasto adicional alimentacion 2025-10',
    '2025-10-11 19:02:00',
    '2025-10-11 19:02:00'
),
(
    '30000000-0000-0000-0000-000000000524',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    82.37,
    '2025-11-09 09:46:00',
    'Gasto mensual educacion 2025-11',
    '2025-11-09 09:46:00',
    '2025-11-09 09:46:00'
),
(
    '30000000-0000-0000-0000-000000000525',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    98.50,
    '2025-11-12 19:09:00',
    'Gasto adicional transporte 2025-11',
    '2025-11-12 19:09:00',
    '2025-11-12 19:09:00'
),
(
    '30000000-0000-0000-0000-000000000526',
    (SELECT id FROM "user" WHERE email = 'ejemplo@user.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    89.74,
    '2025-12-10 09:53:00',
    'Gasto mensual entretenimiento 2025-12',
    '2025-12-10 09:53:00',
    '2025-12-10 09:53:00'
),
(
    '30000000-0000-0000-0000-000000000527',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    129.00,
    '2021-01-12 10:00:00',
    'Gasto mensual transporte 2021-01',
    '2021-01-12 10:00:00',
    '2021-01-12 10:00:00'
),
(
    '30000000-0000-0000-0000-000000000528',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    136.37,
    '2021-02-13 10:07:00',
    'Gasto mensual servicios 2021-02',
    '2021-02-13 10:07:00',
    '2021-02-13 10:07:00'
),
(
    '30000000-0000-0000-0000-000000000529',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    143.74,
    '2021-03-14 10:14:00',
    'Gasto mensual salud 2021-03',
    '2021-03-14 10:14:00',
    '2021-03-14 10:14:00'
),
(
    '30000000-0000-0000-0000-000000000530',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    150.00,
    '2021-04-15 10:21:00',
    'Gasto mensual educacion 2021-04',
    '2021-04-15 10:21:00',
    '2021-04-15 10:21:00'
),
(
    '30000000-0000-0000-0000-000000000531',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    157.37,
    '2021-05-16 10:28:00',
    'Gasto mensual entretenimiento 2021-05',
    '2021-05-16 10:28:00',
    '2021-05-16 10:28:00'
),
(
    '30000000-0000-0000-0000-000000000532',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    164.74,
    '2021-06-17 10:35:00',
    'Gasto mensual alimentacion 2021-06',
    '2021-06-17 10:35:00',
    '2021-06-17 10:35:00'
),
(
    '30000000-0000-0000-0000-000000000533',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    171.00,
    '2021-07-18 10:42:00',
    'Gasto mensual transporte 2021-07',
    '2021-07-18 10:42:00',
    '2021-07-18 10:42:00'
),
(
    '30000000-0000-0000-0000-000000000534',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    37.75,
    '2021-07-21 19:05:00',
    'Gasto adicional educacion 2021-07',
    '2021-07-21 19:05:00',
    '2021-07-21 19:05:00'
),
(
    '30000000-0000-0000-0000-000000000535',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    178.37,
    '2021-08-19 10:49:00',
    'Gasto mensual servicios 2021-08',
    '2021-08-19 10:49:00',
    '2021-08-19 10:49:00'
),
(
    '30000000-0000-0000-0000-000000000536',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    185.74,
    '2021-09-20 10:56:00',
    'Gasto mensual salud 2021-09',
    '2021-09-20 10:56:00',
    '2021-09-20 10:56:00'
),
(
    '30000000-0000-0000-0000-000000000537',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    192.00,
    '2021-10-21 10:03:00',
    'Gasto mensual educacion 2021-10',
    '2021-10-21 10:03:00',
    '2021-10-21 10:03:00'
),
(
    '30000000-0000-0000-0000-000000000538',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    199.37,
    '2021-11-22 10:10:00',
    'Gasto mensual entretenimiento 2021-11',
    '2021-11-22 10:10:00',
    '2021-11-22 10:10:00'
),
(
    '30000000-0000-0000-0000-000000000539',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    206.74,
    '2021-12-23 10:17:00',
    'Gasto mensual alimentacion 2021-12',
    '2021-12-23 10:17:00',
    '2021-12-23 10:17:00'
),
(
    '30000000-0000-0000-0000-000000000540',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    62.75,
    '2021-12-26 19:40:00',
    'Gasto adicional salud 2021-12',
    '2021-12-26 19:40:00',
    '2021-12-26 19:40:00'
),
(
    '30000000-0000-0000-0000-000000000541',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    213.00,
    '2022-01-24 10:24:00',
    'Gasto mensual transporte 2022-01',
    '2022-01-24 10:24:00',
    '2022-01-24 10:24:00'
),
(
    '30000000-0000-0000-0000-000000000542',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    220.37,
    '2022-02-05 10:31:00',
    'Gasto mensual servicios 2022-02',
    '2022-02-05 10:31:00',
    '2022-02-05 10:31:00'
),
(
    '30000000-0000-0000-0000-000000000543',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    227.74,
    '2022-03-06 10:38:00',
    'Gasto mensual salud 2022-03',
    '2022-03-06 10:38:00',
    '2022-03-06 10:38:00'
),
(
    '30000000-0000-0000-0000-000000000544',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    234.00,
    '2022-04-07 10:45:00',
    'Gasto mensual educacion 2022-04',
    '2022-04-07 10:45:00',
    '2022-04-07 10:45:00'
),
(
    '30000000-0000-0000-0000-000000000545',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    241.37,
    '2022-05-08 10:52:00',
    'Gasto mensual entretenimiento 2022-05',
    '2022-05-08 10:52:00',
    '2022-05-08 10:52:00'
),
(
    '30000000-0000-0000-0000-000000000546',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    28.74,
    '2022-06-09 10:59:00',
    'Gasto mensual alimentacion 2022-06',
    '2022-06-09 10:59:00',
    '2022-06-09 10:59:00'
),
(
    '30000000-0000-0000-0000-000000000547',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    35.00,
    '2022-07-10 10:06:00',
    'Gasto mensual transporte 2022-07',
    '2022-07-10 10:06:00',
    '2022-07-10 10:06:00'
),
(
    '30000000-0000-0000-0000-000000000548',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    42.37,
    '2022-08-11 10:13:00',
    'Gasto mensual servicios 2022-08',
    '2022-08-11 10:13:00',
    '2022-08-11 10:13:00'
),
(
    '30000000-0000-0000-0000-000000000549',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    49.74,
    '2022-09-12 10:20:00',
    'Gasto mensual salud 2022-09',
    '2022-09-12 10:20:00',
    '2022-09-12 10:20:00'
),
(
    '30000000-0000-0000-0000-000000000550',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    56.00,
    '2022-10-13 10:27:00',
    'Gasto mensual educacion 2022-10',
    '2022-10-13 10:27:00',
    '2022-10-13 10:27:00'
),
(
    '30000000-0000-0000-0000-000000000551',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    63.37,
    '2022-11-14 10:34:00',
    'Gasto mensual entretenimiento 2022-11',
    '2022-11-14 10:34:00',
    '2022-11-14 10:34:00'
),
(
    '30000000-0000-0000-0000-000000000552',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    22.75,
    '2022-11-17 19:57:00',
    'Gasto adicional servicios 2022-11',
    '2022-11-17 19:57:00',
    '2022-11-17 19:57:00'
),
(
    '30000000-0000-0000-0000-000000000553',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    70.74,
    '2022-12-15 10:41:00',
    'Gasto mensual alimentacion 2022-12',
    '2022-12-15 10:41:00',
    '2022-12-15 10:41:00'
),
(
    '30000000-0000-0000-0000-000000000554',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    77.00,
    '2023-01-16 10:48:00',
    'Gasto mensual transporte 2023-01',
    '2023-01-16 10:48:00',
    '2023-01-16 10:48:00'
),
(
    '30000000-0000-0000-0000-000000000555',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    84.37,
    '2023-02-17 10:55:00',
    'Gasto mensual servicios 2023-02',
    '2023-02-17 10:55:00',
    '2023-02-17 10:55:00'
),
(
    '30000000-0000-0000-0000-000000000556',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    91.74,
    '2023-03-18 10:02:00',
    'Gasto mensual salud 2023-03',
    '2023-03-18 10:02:00',
    '2023-03-18 10:02:00'
),
(
    '30000000-0000-0000-0000-000000000557',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    98.00,
    '2023-04-19 10:09:00',
    'Gasto mensual educacion 2023-04',
    '2023-04-19 10:09:00',
    '2023-04-19 10:09:00'
),
(
    '30000000-0000-0000-0000-000000000558',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    105.37,
    '2023-05-20 10:16:00',
    'Gasto mensual entretenimiento 2023-05',
    '2023-05-20 10:16:00',
    '2023-05-20 10:16:00'
),
(
    '30000000-0000-0000-0000-000000000559',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    112.74,
    '2023-06-21 10:23:00',
    'Gasto mensual alimentacion 2023-06',
    '2023-06-21 10:23:00',
    '2023-06-21 10:23:00'
),
(
    '30000000-0000-0000-0000-000000000560',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    119.00,
    '2023-07-22 10:30:00',
    'Gasto mensual transporte 2023-07',
    '2023-07-22 10:30:00',
    '2023-07-22 10:30:00'
),
(
    '30000000-0000-0000-0000-000000000561',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    126.37,
    '2023-08-23 10:37:00',
    'Gasto mensual servicios 2023-08',
    '2023-08-23 10:37:00',
    '2023-08-23 10:37:00'
),
(
    '30000000-0000-0000-0000-000000000562',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    133.74,
    '2023-09-24 10:44:00',
    'Gasto mensual salud 2023-09',
    '2023-09-24 10:44:00',
    '2023-09-24 10:44:00'
),
(
    '30000000-0000-0000-0000-000000000563',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    140.00,
    '2023-10-05 10:51:00',
    'Gasto mensual educacion 2023-10',
    '2023-10-05 10:51:00',
    '2023-10-05 10:51:00'
),
(
    '30000000-0000-0000-0000-000000000564',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    77.75,
    '2023-10-08 19:14:00',
    'Gasto adicional transporte 2023-10',
    '2023-10-08 19:14:00',
    '2023-10-08 19:14:00'
),
(
    '30000000-0000-0000-0000-000000000565',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    147.37,
    '2023-11-06 10:58:00',
    'Gasto mensual entretenimiento 2023-11',
    '2023-11-06 10:58:00',
    '2023-11-06 10:58:00'
),
(
    '30000000-0000-0000-0000-000000000566',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    154.74,
    '2023-12-07 10:05:00',
    'Gasto mensual alimentacion 2023-12',
    '2023-12-07 10:05:00',
    '2023-12-07 10:05:00'
),
(
    '30000000-0000-0000-0000-000000000567',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    161.00,
    '2024-01-08 10:12:00',
    'Gasto mensual transporte 2024-01',
    '2024-01-08 10:12:00',
    '2024-01-08 10:12:00'
),
(
    '30000000-0000-0000-0000-000000000568',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    168.37,
    '2024-02-09 10:19:00',
    'Gasto mensual servicios 2024-02',
    '2024-02-09 10:19:00',
    '2024-02-09 10:19:00'
),
(
    '30000000-0000-0000-0000-000000000569',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    175.74,
    '2024-03-10 10:26:00',
    'Gasto mensual salud 2024-03',
    '2024-03-10 10:26:00',
    '2024-03-10 10:26:00'
),
(
    '30000000-0000-0000-0000-000000000570',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    182.00,
    '2024-04-11 10:33:00',
    'Gasto mensual educacion 2024-04',
    '2024-04-11 10:33:00',
    '2024-04-11 10:33:00'
),
(
    '30000000-0000-0000-0000-000000000571',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    189.37,
    '2024-05-12 10:40:00',
    'Gasto mensual entretenimiento 2024-05',
    '2024-05-12 10:40:00',
    '2024-05-12 10:40:00'
),
(
    '30000000-0000-0000-0000-000000000572',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    196.74,
    '2024-06-13 10:47:00',
    'Gasto mensual alimentacion 2024-06',
    '2024-06-13 10:47:00',
    '2024-06-13 10:47:00'
),
(
    '30000000-0000-0000-0000-000000000573',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    203.00,
    '2024-07-14 10:54:00',
    'Gasto mensual transporte 2024-07',
    '2024-07-14 10:54:00',
    '2024-07-14 10:54:00'
),
(
    '30000000-0000-0000-0000-000000000574',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    210.37,
    '2024-08-15 10:01:00',
    'Gasto mensual servicios 2024-08',
    '2024-08-15 10:01:00',
    '2024-08-15 10:01:00'
),
(
    '30000000-0000-0000-0000-000000000575',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    217.74,
    '2024-09-16 10:08:00',
    'Gasto mensual salud 2024-09',
    '2024-09-16 10:08:00',
    '2024-09-16 10:08:00'
),
(
    '30000000-0000-0000-0000-000000000576',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    37.75,
    '2024-09-19 19:31:00',
    'Gasto adicional alimentacion 2024-09',
    '2024-09-19 19:31:00',
    '2024-09-19 19:31:00'
),
(
    '30000000-0000-0000-0000-000000000577',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    224.00,
    '2024-10-17 10:15:00',
    'Gasto mensual educacion 2024-10',
    '2024-10-17 10:15:00',
    '2024-10-17 10:15:00'
),
(
    '30000000-0000-0000-0000-000000000578',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    231.37,
    '2024-11-18 10:22:00',
    'Gasto mensual entretenimiento 2024-11',
    '2024-11-18 10:22:00',
    '2024-11-18 10:22:00'
),
(
    '30000000-0000-0000-0000-000000000579',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    238.74,
    '2024-12-19 10:29:00',
    'Gasto mensual alimentacion 2024-12',
    '2024-12-19 10:29:00',
    '2024-12-19 10:29:00'
),
(
    '30000000-0000-0000-0000-000000000580',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    25.00,
    '2025-01-20 10:36:00',
    'Gasto mensual transporte 2025-01',
    '2025-01-20 10:36:00',
    '2025-01-20 10:36:00'
),
(
    '30000000-0000-0000-0000-000000000581',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    32.37,
    '2025-02-21 10:43:00',
    'Gasto mensual servicios 2025-02',
    '2025-02-21 10:43:00',
    '2025-02-21 10:43:00'
),
(
    '30000000-0000-0000-0000-000000000582',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    39.74,
    '2025-03-22 10:50:00',
    'Gasto mensual salud 2025-03',
    '2025-03-22 10:50:00',
    '2025-03-22 10:50:00'
),
(
    '30000000-0000-0000-0000-000000000583',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    46.00,
    '2025-04-23 10:57:00',
    'Gasto mensual educacion 2025-04',
    '2025-04-23 10:57:00',
    '2025-04-23 10:57:00'
),
(
    '30000000-0000-0000-0000-000000000584',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    53.37,
    '2025-05-24 10:04:00',
    'Gasto mensual entretenimiento 2025-05',
    '2025-05-24 10:04:00',
    '2025-05-24 10:04:00'
),
(
    '30000000-0000-0000-0000-000000000585',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    60.74,
    '2025-06-05 10:11:00',
    'Gasto mensual alimentacion 2025-06',
    '2025-06-05 10:11:00',
    '2025-06-05 10:11:00'
),
(
    '30000000-0000-0000-0000-000000000586',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    67.00,
    '2025-07-06 10:18:00',
    'Gasto mensual transporte 2025-07',
    '2025-07-06 10:18:00',
    '2025-07-06 10:18:00'
),
(
    '30000000-0000-0000-0000-000000000587',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    74.37,
    '2025-08-07 10:25:00',
    'Gasto mensual servicios 2025-08',
    '2025-08-07 10:25:00',
    '2025-08-07 10:25:00'
),
(
    '30000000-0000-0000-0000-000000000588',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    92.75,
    '2025-08-10 19:48:00',
    'Gasto adicional entretenimiento 2025-08',
    '2025-08-10 19:48:00',
    '2025-08-10 19:48:00'
),
(
    '30000000-0000-0000-0000-000000000589',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    81.74,
    '2025-09-08 10:32:00',
    'Gasto mensual salud 2025-09',
    '2025-09-08 10:32:00',
    '2025-09-08 10:32:00'
),
(
    '30000000-0000-0000-0000-000000000590',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    88.00,
    '2025-10-09 10:39:00',
    'Gasto mensual educacion 2025-10',
    '2025-10-09 10:39:00',
    '2025-10-09 10:39:00'
),
(
    '30000000-0000-0000-0000-000000000591',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    95.37,
    '2025-11-10 10:46:00',
    'Gasto mensual entretenimiento 2025-11',
    '2025-11-10 10:46:00',
    '2025-11-10 10:46:00'
),
(
    '30000000-0000-0000-0000-000000000592',
    (SELECT id FROM "user" WHERE email = 'ejemplo@admin.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    102.74,
    '2025-12-11 10:53:00',
    'Gasto mensual alimentacion 2025-12',
    '2025-12-11 10:53:00',
    '2025-12-11 10:53:00'
),
(
    '30000000-0000-0000-0000-000000000593',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    142.00,
    '2021-01-13 11:00:00',
    'Gasto mensual servicios 2021-01',
    '2021-01-13 11:00:00',
    '2021-01-13 11:00:00'
),
(
    '30000000-0000-0000-0000-000000000594',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    149.37,
    '2021-02-14 11:07:00',
    'Gasto mensual salud 2021-02',
    '2021-02-14 11:07:00',
    '2021-02-14 11:07:00'
),
(
    '30000000-0000-0000-0000-000000000595',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    156.74,
    '2021-03-15 11:14:00',
    'Gasto mensual educacion 2021-03',
    '2021-03-15 11:14:00',
    '2021-03-15 11:14:00'
),
(
    '30000000-0000-0000-0000-000000000596',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    163.00,
    '2021-04-16 11:21:00',
    'Gasto mensual entretenimiento 2021-04',
    '2021-04-16 11:21:00',
    '2021-04-16 11:21:00'
),
(
    '30000000-0000-0000-0000-000000000597',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    170.37,
    '2021-05-17 11:28:00',
    'Gasto mensual alimentacion 2021-05',
    '2021-05-17 11:28:00',
    '2021-05-17 11:28:00'
),
(
    '30000000-0000-0000-0000-000000000598',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    36.00,
    '2021-05-20 19:51:00',
    'Gasto adicional salud 2021-05',
    '2021-05-20 19:51:00',
    '2021-05-20 19:51:00'
),
(
    '30000000-0000-0000-0000-000000000599',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    177.74,
    '2021-06-18 11:35:00',
    'Gasto mensual transporte 2021-06',
    '2021-06-18 11:35:00',
    '2021-06-18 11:35:00'
),
(
    '30000000-0000-0000-0000-000000000600',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    41.00,
    '2021-06-21 19:58:00',
    'Gasto adicional educacion 2021-06',
    '2021-06-21 19:58:00',
    '2021-06-21 19:58:00'
),
(
    '30000000-0000-0000-0000-000000000601',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    184.00,
    '2021-07-19 11:42:00',
    'Gasto mensual servicios 2021-07',
    '2021-07-19 11:42:00',
    '2021-07-19 11:42:00'
),
(
    '30000000-0000-0000-0000-000000000602',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    191.37,
    '2021-08-20 11:49:00',
    'Gasto mensual salud 2021-08',
    '2021-08-20 11:49:00',
    '2021-08-20 11:49:00'
),
(
    '30000000-0000-0000-0000-000000000603',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    198.74,
    '2021-09-21 11:56:00',
    'Gasto mensual educacion 2021-09',
    '2021-09-21 11:56:00',
    '2021-09-21 11:56:00'
),
(
    '30000000-0000-0000-0000-000000000604',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    205.00,
    '2021-10-22 11:03:00',
    'Gasto mensual entretenimiento 2021-10',
    '2021-10-22 11:03:00',
    '2021-10-22 11:03:00'
),
(
    '30000000-0000-0000-0000-000000000605',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    212.37,
    '2021-11-23 11:10:00',
    'Gasto mensual alimentacion 2021-11',
    '2021-11-23 11:10:00',
    '2021-11-23 11:10:00'
),
(
    '30000000-0000-0000-0000-000000000606',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    66.00,
    '2021-11-26 19:33:00',
    'Gasto adicional salud 2021-11',
    '2021-11-26 19:33:00',
    '2021-11-26 19:33:00'
),
(
    '30000000-0000-0000-0000-000000000607',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    219.74,
    '2021-12-24 11:17:00',
    'Gasto mensual transporte 2021-12',
    '2021-12-24 11:17:00',
    '2021-12-24 11:17:00'
),
(
    '30000000-0000-0000-0000-000000000608',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    226.00,
    '2022-01-05 11:24:00',
    'Gasto mensual servicios 2022-01',
    '2022-01-05 11:24:00',
    '2022-01-05 11:24:00'
),
(
    '30000000-0000-0000-0000-000000000609',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    233.37,
    '2022-02-06 11:31:00',
    'Gasto mensual salud 2022-02',
    '2022-02-06 11:31:00',
    '2022-02-06 11:31:00'
),
(
    '30000000-0000-0000-0000-000000000610',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    240.74,
    '2022-03-07 11:38:00',
    'Gasto mensual educacion 2022-03',
    '2022-03-07 11:38:00',
    '2022-03-07 11:38:00'
),
(
    '30000000-0000-0000-0000-000000000611',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    27.00,
    '2022-04-08 11:45:00',
    'Gasto mensual entretenimiento 2022-04',
    '2022-04-08 11:45:00',
    '2022-04-08 11:45:00'
),
(
    '30000000-0000-0000-0000-000000000612',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    91.00,
    '2022-04-11 19:08:00',
    'Gasto adicional servicios 2022-04',
    '2022-04-11 19:08:00',
    '2022-04-11 19:08:00'
),
(
    '30000000-0000-0000-0000-000000000613',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    34.37,
    '2022-05-09 11:52:00',
    'Gasto mensual alimentacion 2022-05',
    '2022-05-09 11:52:00',
    '2022-05-09 11:52:00'
),
(
    '30000000-0000-0000-0000-000000000614',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    96.00,
    '2022-05-12 19:15:00',
    'Gasto adicional salud 2022-05',
    '2022-05-12 19:15:00',
    '2022-05-12 19:15:00'
),
(
    '30000000-0000-0000-0000-000000000615',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    41.74,
    '2022-06-10 11:59:00',
    'Gasto mensual transporte 2022-06',
    '2022-06-10 11:59:00',
    '2022-06-10 11:59:00'
),
(
    '30000000-0000-0000-0000-000000000616',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    48.00,
    '2022-07-11 11:06:00',
    'Gasto mensual servicios 2022-07',
    '2022-07-11 11:06:00',
    '2022-07-11 11:06:00'
),
(
    '30000000-0000-0000-0000-000000000617',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    55.37,
    '2022-08-12 11:13:00',
    'Gasto mensual salud 2022-08',
    '2022-08-12 11:13:00',
    '2022-08-12 11:13:00'
),
(
    '30000000-0000-0000-0000-000000000618',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    62.74,
    '2022-09-13 11:20:00',
    'Gasto mensual educacion 2022-09',
    '2022-09-13 11:20:00',
    '2022-09-13 11:20:00'
),
(
    '30000000-0000-0000-0000-000000000619',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    69.00,
    '2022-10-14 11:27:00',
    'Gasto mensual entretenimiento 2022-10',
    '2022-10-14 11:27:00',
    '2022-10-14 11:27:00'
),
(
    '30000000-0000-0000-0000-000000000620',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    26.00,
    '2022-10-17 19:50:00',
    'Gasto adicional servicios 2022-10',
    '2022-10-17 19:50:00',
    '2022-10-17 19:50:00'
),
(
    '30000000-0000-0000-0000-000000000621',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    76.37,
    '2022-11-15 11:34:00',
    'Gasto mensual alimentacion 2022-11',
    '2022-11-15 11:34:00',
    '2022-11-15 11:34:00'
),
(
    '30000000-0000-0000-0000-000000000622',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    83.74,
    '2022-12-16 11:41:00',
    'Gasto mensual transporte 2022-12',
    '2022-12-16 11:41:00',
    '2022-12-16 11:41:00'
),
(
    '30000000-0000-0000-0000-000000000623',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    90.00,
    '2023-01-17 11:48:00',
    'Gasto mensual servicios 2023-01',
    '2023-01-17 11:48:00',
    '2023-01-17 11:48:00'
),
(
    '30000000-0000-0000-0000-000000000624',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    97.37,
    '2023-02-18 11:55:00',
    'Gasto mensual salud 2023-02',
    '2023-02-18 11:55:00',
    '2023-02-18 11:55:00'
),
(
    '30000000-0000-0000-0000-000000000625',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    104.74,
    '2023-03-19 11:02:00',
    'Gasto mensual educacion 2023-03',
    '2023-03-19 11:02:00',
    '2023-03-19 11:02:00'
),
(
    '30000000-0000-0000-0000-000000000626',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    51.00,
    '2023-03-22 19:25:00',
    'Gasto adicional transporte 2023-03',
    '2023-03-22 19:25:00',
    '2023-03-22 19:25:00'
),
(
    '30000000-0000-0000-0000-000000000627',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    111.00,
    '2023-04-20 11:09:00',
    'Gasto mensual entretenimiento 2023-04',
    '2023-04-20 11:09:00',
    '2023-04-20 11:09:00'
),
(
    '30000000-0000-0000-0000-000000000628',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    56.00,
    '2023-04-23 19:32:00',
    'Gasto adicional servicios 2023-04',
    '2023-04-23 19:32:00',
    '2023-04-23 19:32:00'
),
(
    '30000000-0000-0000-0000-000000000629',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    118.37,
    '2023-05-21 11:16:00',
    'Gasto mensual alimentacion 2023-05',
    '2023-05-21 11:16:00',
    '2023-05-21 11:16:00'
),
(
    '30000000-0000-0000-0000-000000000630',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    125.74,
    '2023-06-22 11:23:00',
    'Gasto mensual transporte 2023-06',
    '2023-06-22 11:23:00',
    '2023-06-22 11:23:00'
),
(
    '30000000-0000-0000-0000-000000000631',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    132.00,
    '2023-07-23 11:30:00',
    'Gasto mensual servicios 2023-07',
    '2023-07-23 11:30:00',
    '2023-07-23 11:30:00'
),
(
    '30000000-0000-0000-0000-000000000632',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    139.37,
    '2023-08-24 11:37:00',
    'Gasto mensual salud 2023-08',
    '2023-08-24 11:37:00',
    '2023-08-24 11:37:00'
),
(
    '30000000-0000-0000-0000-000000000633',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    146.74,
    '2023-09-05 11:44:00',
    'Gasto mensual educacion 2023-09',
    '2023-09-05 11:44:00',
    '2023-09-05 11:44:00'
),
(
    '30000000-0000-0000-0000-000000000634',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    81.00,
    '2023-09-08 19:07:00',
    'Gasto adicional transporte 2023-09',
    '2023-09-08 19:07:00',
    '2023-09-08 19:07:00'
),
(
    '30000000-0000-0000-0000-000000000635',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    153.00,
    '2023-10-06 11:51:00',
    'Gasto mensual entretenimiento 2023-10',
    '2023-10-06 11:51:00',
    '2023-10-06 11:51:00'
),
(
    '30000000-0000-0000-0000-000000000636',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    160.37,
    '2023-11-07 11:58:00',
    'Gasto mensual alimentacion 2023-11',
    '2023-11-07 11:58:00',
    '2023-11-07 11:58:00'
),
(
    '30000000-0000-0000-0000-000000000637',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    167.74,
    '2023-12-08 11:05:00',
    'Gasto mensual transporte 2023-12',
    '2023-12-08 11:05:00',
    '2023-12-08 11:05:00'
),
(
    '30000000-0000-0000-0000-000000000638',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    174.00,
    '2024-01-09 11:12:00',
    'Gasto mensual servicios 2024-01',
    '2024-01-09 11:12:00',
    '2024-01-09 11:12:00'
),
(
    '30000000-0000-0000-0000-000000000639',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    181.37,
    '2024-02-10 11:19:00',
    'Gasto mensual salud 2024-02',
    '2024-02-10 11:19:00',
    '2024-02-10 11:19:00'
),
(
    '30000000-0000-0000-0000-000000000640',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    106.00,
    '2024-02-13 19:42:00',
    'Gasto adicional alimentacion 2024-02',
    '2024-02-13 19:42:00',
    '2024-02-13 19:42:00'
),
(
    '30000000-0000-0000-0000-000000000641',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    188.74,
    '2024-03-11 11:26:00',
    'Gasto mensual educacion 2024-03',
    '2024-03-11 11:26:00',
    '2024-03-11 11:26:00'
),
(
    '30000000-0000-0000-0000-000000000642',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    195.00,
    '2024-04-12 11:33:00',
    'Gasto mensual entretenimiento 2024-04',
    '2024-04-12 11:33:00',
    '2024-04-12 11:33:00'
),
(
    '30000000-0000-0000-0000-000000000643',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    202.37,
    '2024-05-13 11:40:00',
    'Gasto mensual alimentacion 2024-05',
    '2024-05-13 11:40:00',
    '2024-05-13 11:40:00'
),
(
    '30000000-0000-0000-0000-000000000644',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    209.74,
    '2024-06-14 11:47:00',
    'Gasto mensual transporte 2024-06',
    '2024-06-14 11:47:00',
    '2024-06-14 11:47:00'
),
(
    '30000000-0000-0000-0000-000000000645',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    216.00,
    '2024-07-15 11:54:00',
    'Gasto mensual servicios 2024-07',
    '2024-07-15 11:54:00',
    '2024-07-15 11:54:00'
),
(
    '30000000-0000-0000-0000-000000000646',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    223.37,
    '2024-08-16 11:01:00',
    'Gasto mensual salud 2024-08',
    '2024-08-16 11:01:00',
    '2024-08-16 11:01:00'
),
(
    '30000000-0000-0000-0000-000000000647',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    41.00,
    '2024-08-19 19:24:00',
    'Gasto adicional alimentacion 2024-08',
    '2024-08-19 19:24:00',
    '2024-08-19 19:24:00'
),
(
    '30000000-0000-0000-0000-000000000648',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    230.74,
    '2024-09-17 11:08:00',
    'Gasto mensual educacion 2024-09',
    '2024-09-17 11:08:00',
    '2024-09-17 11:08:00'
),
(
    '30000000-0000-0000-0000-000000000649',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    237.00,
    '2024-10-18 11:15:00',
    'Gasto mensual entretenimiento 2024-10',
    '2024-10-18 11:15:00',
    '2024-10-18 11:15:00'
),
(
    '30000000-0000-0000-0000-000000000650',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    244.37,
    '2024-11-19 11:22:00',
    'Gasto mensual alimentacion 2024-11',
    '2024-11-19 11:22:00',
    '2024-11-19 11:22:00'
),
(
    '30000000-0000-0000-0000-000000000651',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    31.74,
    '2024-12-20 11:29:00',
    'Gasto mensual transporte 2024-12',
    '2024-12-20 11:29:00',
    '2024-12-20 11:29:00'
),
(
    '30000000-0000-0000-0000-000000000652',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    38.00,
    '2025-01-21 11:36:00',
    'Gasto mensual servicios 2025-01',
    '2025-01-21 11:36:00',
    '2025-01-21 11:36:00'
),
(
    '30000000-0000-0000-0000-000000000653',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    66.00,
    '2025-01-24 19:59:00',
    'Gasto adicional entretenimiento 2025-01',
    '2025-01-24 19:59:00',
    '2025-01-24 19:59:00'
),
(
    '30000000-0000-0000-0000-000000000654',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    45.37,
    '2025-02-22 11:43:00',
    'Gasto mensual salud 2025-02',
    '2025-02-22 11:43:00',
    '2025-02-22 11:43:00'
),
(
    '30000000-0000-0000-0000-000000000655',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    52.74,
    '2025-03-23 11:50:00',
    'Gasto mensual educacion 2025-03',
    '2025-03-23 11:50:00',
    '2025-03-23 11:50:00'
),
(
    '30000000-0000-0000-0000-000000000656',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    59.00,
    '2025-04-24 11:57:00',
    'Gasto mensual entretenimiento 2025-04',
    '2025-04-24 11:57:00',
    '2025-04-24 11:57:00'
),
(
    '30000000-0000-0000-0000-000000000657',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    66.37,
    '2025-05-05 11:04:00',
    'Gasto mensual alimentacion 2025-05',
    '2025-05-05 11:04:00',
    '2025-05-05 11:04:00'
),
(
    '30000000-0000-0000-0000-000000000658',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    73.74,
    '2025-06-06 11:11:00',
    'Gasto mensual transporte 2025-06',
    '2025-06-06 11:11:00',
    '2025-06-06 11:11:00'
),
(
    '30000000-0000-0000-0000-000000000659',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    80.00,
    '2025-07-07 11:18:00',
    'Gasto mensual servicios 2025-07',
    '2025-07-07 11:18:00',
    '2025-07-07 11:18:00'
),
(
    '30000000-0000-0000-0000-000000000660',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    96.00,
    '2025-07-10 19:41:00',
    'Gasto adicional entretenimiento 2025-07',
    '2025-07-10 19:41:00',
    '2025-07-10 19:41:00'
),
(
    '30000000-0000-0000-0000-000000000661',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    87.37,
    '2025-08-08 11:25:00',
    'Gasto mensual salud 2025-08',
    '2025-08-08 11:25:00',
    '2025-08-08 11:25:00'
),
(
    '30000000-0000-0000-0000-000000000662',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    94.74,
    '2025-09-09 11:32:00',
    'Gasto mensual educacion 2025-09',
    '2025-09-09 11:32:00',
    '2025-09-09 11:32:00'
),
(
    '30000000-0000-0000-0000-000000000663',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    101.00,
    '2025-10-10 11:39:00',
    'Gasto mensual entretenimiento 2025-10',
    '2025-10-10 11:39:00',
    '2025-10-10 11:39:00'
),
(
    '30000000-0000-0000-0000-000000000664',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    108.37,
    '2025-11-11 11:46:00',
    'Gasto mensual alimentacion 2025-11',
    '2025-11-11 11:46:00',
    '2025-11-11 11:46:00'
),
(
    '30000000-0000-0000-0000-000000000665',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    115.74,
    '2025-12-12 11:53:00',
    'Gasto mensual transporte 2025-12',
    '2025-12-12 11:53:00',
    '2025-12-12 11:53:00'
),
(
    '30000000-0000-0000-0000-000000000666',
    (SELECT id FROM "user" WHERE email = 'ejemplo@owner.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    26.00,
    '2025-12-15 19:16:00',
    'Gasto adicional educacion 2025-12',
    '2025-12-15 19:16:00',
    '2025-12-15 19:16:00'
),
(
    '30000000-0000-0000-0000-000000000667',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    155.00,
    '2021-01-14 12:00:00',
    'Gasto mensual salud 2021-01',
    '2021-01-14 12:00:00',
    '2021-01-14 12:00:00'
),
(
    '30000000-0000-0000-0000-000000000668',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    162.37,
    '2021-02-15 12:07:00',
    'Gasto mensual educacion 2021-02',
    '2021-02-15 12:07:00',
    '2021-02-15 12:07:00'
),
(
    '30000000-0000-0000-0000-000000000669',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    169.74,
    '2021-03-16 12:14:00',
    'Gasto mensual entretenimiento 2021-03',
    '2021-03-16 12:14:00',
    '2021-03-16 12:14:00'
),
(
    '30000000-0000-0000-0000-000000000670',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    176.00,
    '2021-04-17 12:21:00',
    'Gasto mensual alimentacion 2021-04',
    '2021-04-17 12:21:00',
    '2021-04-17 12:21:00'
),
(
    '30000000-0000-0000-0000-000000000671',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    40.25,
    '2021-04-20 19:44:00',
    'Gasto adicional salud 2021-04',
    '2021-04-20 19:44:00',
    '2021-04-20 19:44:00'
),
(
    '30000000-0000-0000-0000-000000000672',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    183.37,
    '2021-05-18 12:28:00',
    'Gasto mensual transporte 2021-05',
    '2021-05-18 12:28:00',
    '2021-05-18 12:28:00'
),
(
    '30000000-0000-0000-0000-000000000673',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    45.25,
    '2021-05-21 19:51:00',
    'Gasto adicional educacion 2021-05',
    '2021-05-21 19:51:00',
    '2021-05-21 19:51:00'
),
(
    '30000000-0000-0000-0000-000000000674',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    190.74,
    '2021-06-19 12:35:00',
    'Gasto mensual servicios 2021-06',
    '2021-06-19 12:35:00',
    '2021-06-19 12:35:00'
),
(
    '30000000-0000-0000-0000-000000000675',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    197.00,
    '2021-07-20 12:42:00',
    'Gasto mensual salud 2021-07',
    '2021-07-20 12:42:00',
    '2021-07-20 12:42:00'
),
(
    '30000000-0000-0000-0000-000000000676',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    204.37,
    '2021-08-21 12:49:00',
    'Gasto mensual educacion 2021-08',
    '2021-08-21 12:49:00',
    '2021-08-21 12:49:00'
),
(
    '30000000-0000-0000-0000-000000000677',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    211.74,
    '2021-09-22 12:56:00',
    'Gasto mensual entretenimiento 2021-09',
    '2021-09-22 12:56:00',
    '2021-09-22 12:56:00'
),
(
    '30000000-0000-0000-0000-000000000678',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    65.25,
    '2021-09-25 19:19:00',
    'Gasto adicional servicios 2021-09',
    '2021-09-25 19:19:00',
    '2021-09-25 19:19:00'
),
(
    '30000000-0000-0000-0000-000000000679',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    218.00,
    '2021-10-23 12:03:00',
    'Gasto mensual alimentacion 2021-10',
    '2021-10-23 12:03:00',
    '2021-10-23 12:03:00'
),
(
    '30000000-0000-0000-0000-000000000680',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    70.25,
    '2021-10-26 19:26:00',
    'Gasto adicional salud 2021-10',
    '2021-10-26 19:26:00',
    '2021-10-26 19:26:00'
),
(
    '30000000-0000-0000-0000-000000000681',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    225.37,
    '2021-11-24 12:10:00',
    'Gasto mensual transporte 2021-11',
    '2021-11-24 12:10:00',
    '2021-11-24 12:10:00'
),
(
    '30000000-0000-0000-0000-000000000682',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    232.74,
    '2021-12-05 12:17:00',
    'Gasto mensual servicios 2021-12',
    '2021-12-05 12:17:00',
    '2021-12-05 12:17:00'
),
(
    '30000000-0000-0000-0000-000000000683',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    239.00,
    '2022-01-06 12:24:00',
    'Gasto mensual salud 2022-01',
    '2022-01-06 12:24:00',
    '2022-01-06 12:24:00'
),
(
    '30000000-0000-0000-0000-000000000684',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    26.37,
    '2022-02-07 12:31:00',
    'Gasto mensual educacion 2022-02',
    '2022-02-07 12:31:00',
    '2022-02-07 12:31:00'
),
(
    '30000000-0000-0000-0000-000000000685',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    33.74,
    '2022-03-08 12:38:00',
    'Gasto mensual entretenimiento 2022-03',
    '2022-03-08 12:38:00',
    '2022-03-08 12:38:00'
),
(
    '30000000-0000-0000-0000-000000000686',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    95.25,
    '2022-03-11 19:01:00',
    'Gasto adicional servicios 2022-03',
    '2022-03-11 19:01:00',
    '2022-03-11 19:01:00'
),
(
    '30000000-0000-0000-0000-000000000687',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    40.00,
    '2022-04-09 12:45:00',
    'Gasto mensual alimentacion 2022-04',
    '2022-04-09 12:45:00',
    '2022-04-09 12:45:00'
),
(
    '30000000-0000-0000-0000-000000000688',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    100.25,
    '2022-04-12 19:08:00',
    'Gasto adicional salud 2022-04',
    '2022-04-12 19:08:00',
    '2022-04-12 19:08:00'
),
(
    '30000000-0000-0000-0000-000000000689',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    47.37,
    '2022-05-10 12:52:00',
    'Gasto mensual transporte 2022-05',
    '2022-05-10 12:52:00',
    '2022-05-10 12:52:00'
),
(
    '30000000-0000-0000-0000-000000000690',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    54.74,
    '2022-06-11 12:59:00',
    'Gasto mensual servicios 2022-06',
    '2022-06-11 12:59:00',
    '2022-06-11 12:59:00'
),
(
    '30000000-0000-0000-0000-000000000691',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    61.00,
    '2022-07-12 12:06:00',
    'Gasto mensual salud 2022-07',
    '2022-07-12 12:06:00',
    '2022-07-12 12:06:00'
),
(
    '30000000-0000-0000-0000-000000000692',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    68.37,
    '2022-08-13 12:13:00',
    'Gasto mensual educacion 2022-08',
    '2022-08-13 12:13:00',
    '2022-08-13 12:13:00'
),
(
    '30000000-0000-0000-0000-000000000693',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    25.25,
    '2022-08-16 19:36:00',
    'Gasto adicional transporte 2022-08',
    '2022-08-16 19:36:00',
    '2022-08-16 19:36:00'
),
(
    '30000000-0000-0000-0000-000000000694',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    75.74,
    '2022-09-14 12:20:00',
    'Gasto mensual entretenimiento 2022-09',
    '2022-09-14 12:20:00',
    '2022-09-14 12:20:00'
),
(
    '30000000-0000-0000-0000-000000000695',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    30.25,
    '2022-09-17 19:43:00',
    'Gasto adicional servicios 2022-09',
    '2022-09-17 19:43:00',
    '2022-09-17 19:43:00'
),
(
    '30000000-0000-0000-0000-000000000696',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    82.00,
    '2022-10-15 12:27:00',
    'Gasto mensual alimentacion 2022-10',
    '2022-10-15 12:27:00',
    '2022-10-15 12:27:00'
),
(
    '30000000-0000-0000-0000-000000000697',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    89.37,
    '2022-11-16 12:34:00',
    'Gasto mensual transporte 2022-11',
    '2022-11-16 12:34:00',
    '2022-11-16 12:34:00'
),
(
    '30000000-0000-0000-0000-000000000698',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    96.74,
    '2022-12-17 12:41:00',
    'Gasto mensual servicios 2022-12',
    '2022-12-17 12:41:00',
    '2022-12-17 12:41:00'
),
(
    '30000000-0000-0000-0000-000000000699',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    103.00,
    '2023-01-18 12:48:00',
    'Gasto mensual salud 2023-01',
    '2023-01-18 12:48:00',
    '2023-01-18 12:48:00'
),
(
    '30000000-0000-0000-0000-000000000700',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    110.37,
    '2023-02-19 12:55:00',
    'Gasto mensual educacion 2023-02',
    '2023-02-19 12:55:00',
    '2023-02-19 12:55:00'
),
(
    '30000000-0000-0000-0000-000000000701',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    55.25,
    '2023-02-22 19:18:00',
    'Gasto adicional transporte 2023-02',
    '2023-02-22 19:18:00',
    '2023-02-22 19:18:00'
),
(
    '30000000-0000-0000-0000-000000000702',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    117.74,
    '2023-03-20 12:02:00',
    'Gasto mensual entretenimiento 2023-03',
    '2023-03-20 12:02:00',
    '2023-03-20 12:02:00'
),
(
    '30000000-0000-0000-0000-000000000703',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    60.25,
    '2023-03-23 19:25:00',
    'Gasto adicional servicios 2023-03',
    '2023-03-23 19:25:00',
    '2023-03-23 19:25:00'
),
(
    '30000000-0000-0000-0000-000000000704',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    124.00,
    '2023-04-21 12:09:00',
    'Gasto mensual alimentacion 2023-04',
    '2023-04-21 12:09:00',
    '2023-04-21 12:09:00'
),
(
    '30000000-0000-0000-0000-000000000705',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    131.37,
    '2023-05-22 12:16:00',
    'Gasto mensual transporte 2023-05',
    '2023-05-22 12:16:00',
    '2023-05-22 12:16:00'
),
(
    '30000000-0000-0000-0000-000000000706',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    138.74,
    '2023-06-23 12:23:00',
    'Gasto mensual servicios 2023-06',
    '2023-06-23 12:23:00',
    '2023-06-23 12:23:00'
),
(
    '30000000-0000-0000-0000-000000000707',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    145.00,
    '2023-07-24 12:30:00',
    'Gasto mensual salud 2023-07',
    '2023-07-24 12:30:00',
    '2023-07-24 12:30:00'
),
(
    '30000000-0000-0000-0000-000000000708',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    80.25,
    '2023-07-27 19:53:00',
    'Gasto adicional alimentacion 2023-07',
    '2023-07-27 19:53:00',
    '2023-07-27 19:53:00'
),
(
    '30000000-0000-0000-0000-000000000709',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    152.37,
    '2023-08-05 12:37:00',
    'Gasto mensual educacion 2023-08',
    '2023-08-05 12:37:00',
    '2023-08-05 12:37:00'
),
(
    '30000000-0000-0000-0000-000000000710',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    85.25,
    '2023-08-08 19:00:00',
    'Gasto adicional transporte 2023-08',
    '2023-08-08 19:00:00',
    '2023-08-08 19:00:00'
),
(
    '30000000-0000-0000-0000-000000000711',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    159.74,
    '2023-09-06 12:44:00',
    'Gasto mensual entretenimiento 2023-09',
    '2023-09-06 12:44:00',
    '2023-09-06 12:44:00'
),
(
    '30000000-0000-0000-0000-000000000712',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    166.00,
    '2023-10-07 12:51:00',
    'Gasto mensual alimentacion 2023-10',
    '2023-10-07 12:51:00',
    '2023-10-07 12:51:00'
),
(
    '30000000-0000-0000-0000-000000000713',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    173.37,
    '2023-11-08 12:58:00',
    'Gasto mensual transporte 2023-11',
    '2023-11-08 12:58:00',
    '2023-11-08 12:58:00'
),
(
    '30000000-0000-0000-0000-000000000714',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    180.74,
    '2023-12-09 12:05:00',
    'Gasto mensual servicios 2023-12',
    '2023-12-09 12:05:00',
    '2023-12-09 12:05:00'
),
(
    '30000000-0000-0000-0000-000000000715',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    187.00,
    '2024-01-10 12:12:00',
    'Gasto mensual salud 2024-01',
    '2024-01-10 12:12:00',
    '2024-01-10 12:12:00'
),
(
    '30000000-0000-0000-0000-000000000716',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    15.25,
    '2024-01-13 19:35:00',
    'Gasto adicional alimentacion 2024-01',
    '2024-01-13 19:35:00',
    '2024-01-13 19:35:00'
),
(
    '30000000-0000-0000-0000-000000000717',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    194.37,
    '2024-02-11 12:19:00',
    'Gasto mensual educacion 2024-02',
    '2024-02-11 12:19:00',
    '2024-02-11 12:19:00'
),
(
    '30000000-0000-0000-0000-000000000718',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    201.74,
    '2024-03-12 12:26:00',
    'Gasto mensual entretenimiento 2024-03',
    '2024-03-12 12:26:00',
    '2024-03-12 12:26:00'
),
(
    '30000000-0000-0000-0000-000000000719',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    208.00,
    '2024-04-13 12:33:00',
    'Gasto mensual alimentacion 2024-04',
    '2024-04-13 12:33:00',
    '2024-04-13 12:33:00'
),
(
    '30000000-0000-0000-0000-000000000720',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    215.37,
    '2024-05-14 12:40:00',
    'Gasto mensual transporte 2024-05',
    '2024-05-14 12:40:00',
    '2024-05-14 12:40:00'
),
(
    '30000000-0000-0000-0000-000000000721',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    222.74,
    '2024-06-15 12:47:00',
    'Gasto mensual servicios 2024-06',
    '2024-06-15 12:47:00',
    '2024-06-15 12:47:00'
),
(
    '30000000-0000-0000-0000-000000000722',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    40.25,
    '2024-06-18 19:10:00',
    'Gasto adicional entretenimiento 2024-06',
    '2024-06-18 19:10:00',
    '2024-06-18 19:10:00'
),
(
    '30000000-0000-0000-0000-000000000723',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    229.00,
    '2024-07-16 12:54:00',
    'Gasto mensual salud 2024-07',
    '2024-07-16 12:54:00',
    '2024-07-16 12:54:00'
),
(
    '30000000-0000-0000-0000-000000000724',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    45.25,
    '2024-07-19 19:17:00',
    'Gasto adicional alimentacion 2024-07',
    '2024-07-19 19:17:00',
    '2024-07-19 19:17:00'
),
(
    '30000000-0000-0000-0000-000000000725',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    236.37,
    '2024-08-17 12:01:00',
    'Gasto mensual educacion 2024-08',
    '2024-08-17 12:01:00',
    '2024-08-17 12:01:00'
),
(
    '30000000-0000-0000-0000-000000000726',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    243.74,
    '2024-09-18 12:08:00',
    'Gasto mensual entretenimiento 2024-09',
    '2024-09-18 12:08:00',
    '2024-09-18 12:08:00'
),
(
    '30000000-0000-0000-0000-000000000727',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    30.00,
    '2024-10-19 12:15:00',
    'Gasto mensual alimentacion 2024-10',
    '2024-10-19 12:15:00',
    '2024-10-19 12:15:00'
),
(
    '30000000-0000-0000-0000-000000000728',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    37.37,
    '2024-11-20 12:22:00',
    'Gasto mensual transporte 2024-11',
    '2024-11-20 12:22:00',
    '2024-11-20 12:22:00'
),
(
    '30000000-0000-0000-0000-000000000729',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    44.74,
    '2024-12-21 12:29:00',
    'Gasto mensual servicios 2024-12',
    '2024-12-21 12:29:00',
    '2024-12-21 12:29:00'
),
(
    '30000000-0000-0000-0000-000000000730',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    70.25,
    '2024-12-24 19:52:00',
    'Gasto adicional entretenimiento 2024-12',
    '2024-12-24 19:52:00',
    '2024-12-24 19:52:00'
),
(
    '30000000-0000-0000-0000-000000000731',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    51.00,
    '2025-01-22 12:36:00',
    'Gasto mensual salud 2025-01',
    '2025-01-22 12:36:00',
    '2025-01-22 12:36:00'
),
(
    '30000000-0000-0000-0000-000000000732',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    58.37,
    '2025-02-23 12:43:00',
    'Gasto mensual educacion 2025-02',
    '2025-02-23 12:43:00',
    '2025-02-23 12:43:00'
),
(
    '30000000-0000-0000-0000-000000000733',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    65.74,
    '2025-03-24 12:50:00',
    'Gasto mensual entretenimiento 2025-03',
    '2025-03-24 12:50:00',
    '2025-03-24 12:50:00'
),
(
    '30000000-0000-0000-0000-000000000734',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    72.00,
    '2025-04-05 12:57:00',
    'Gasto mensual alimentacion 2025-04',
    '2025-04-05 12:57:00',
    '2025-04-05 12:57:00'
),
(
    '30000000-0000-0000-0000-000000000735',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    79.37,
    '2025-05-06 12:04:00',
    'Gasto mensual transporte 2025-05',
    '2025-05-06 12:04:00',
    '2025-05-06 12:04:00'
),
(
    '30000000-0000-0000-0000-000000000736',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    95.25,
    '2025-05-09 19:27:00',
    'Gasto adicional educacion 2025-05',
    '2025-05-09 19:27:00',
    '2025-05-09 19:27:00'
),
(
    '30000000-0000-0000-0000-000000000737',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    86.74,
    '2025-06-07 12:11:00',
    'Gasto mensual servicios 2025-06',
    '2025-06-07 12:11:00',
    '2025-06-07 12:11:00'
),
(
    '30000000-0000-0000-0000-000000000738',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    100.25,
    '2025-06-10 19:34:00',
    'Gasto adicional entretenimiento 2025-06',
    '2025-06-10 19:34:00',
    '2025-06-10 19:34:00'
),
(
    '30000000-0000-0000-0000-000000000739',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    93.00,
    '2025-07-08 12:18:00',
    'Gasto mensual salud 2025-07',
    '2025-07-08 12:18:00',
    '2025-07-08 12:18:00'
),
(
    '30000000-0000-0000-0000-000000000740',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    100.37,
    '2025-08-09 12:25:00',
    'Gasto mensual educacion 2025-08',
    '2025-08-09 12:25:00',
    '2025-08-09 12:25:00'
),
(
    '30000000-0000-0000-0000-000000000741',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Entretenimiento'),
    107.74,
    '2025-09-10 12:32:00',
    'Gasto mensual entretenimiento 2025-09',
    '2025-09-10 12:32:00',
    '2025-09-10 12:32:00'
),
(
    '30000000-0000-0000-0000-000000000742',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Alimentacion'),
    114.00,
    '2025-10-11 12:39:00',
    'Gasto mensual alimentacion 2025-10',
    '2025-10-11 12:39:00',
    '2025-10-11 12:39:00'
),
(
    '30000000-0000-0000-0000-000000000743',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Salud'),
    25.25,
    '2025-10-14 19:02:00',
    'Gasto adicional salud 2025-10',
    '2025-10-14 19:02:00',
    '2025-10-14 19:02:00'
),
(
    '30000000-0000-0000-0000-000000000744',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Transporte'),
    121.37,
    '2025-11-12 12:46:00',
    'Gasto mensual transporte 2025-11',
    '2025-11-12 12:46:00',
    '2025-11-12 12:46:00'
),
(
    '30000000-0000-0000-0000-000000000745',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Educacion'),
    30.25,
    '2025-11-15 19:09:00',
    'Gasto adicional educacion 2025-11',
    '2025-11-15 19:09:00',
    '2025-11-15 19:09:00'
),
(
    '30000000-0000-0000-0000-000000000746',
    (SELECT id FROM "user" WHERE email = 'ejemplo@auditor.com'),
    (SELECT id FROM category WHERE name = 'Servicios'),
    128.74,
    '2025-12-13 12:53:00',
    'Gasto mensual servicios 2025-12',
    '2025-12-13 12:53:00',
    '2025-12-13 12:53:00'
)
ON CONFLICT (id) DO UPDATE
SET
    user_id = EXCLUDED.user_id,
    category_id = EXCLUDED.category_id,
    amount = EXCLUDED.amount,
    expense_date = EXCLUDED.expense_date,
    description = EXCLUDED.description,
    created_at = EXCLUDED.created_at,
    updated_at = EXCLUDED.updated_at;
INSERT INTO access_log (
    id,
    user_id,
    event_type,
    attempt_email,
    created_at,
    ip_address,
    web_agent
)
VALUES
(
    '40000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.owner@finanzas.pe',
    '2026-02-24 07:00:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.auditor@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.auditor@finanzas.pe',
    '2026-02-24 07:10:00',
    '127.0.0.1',
    'Firefox'
),
(
    '40000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.admin@finanzas.pe',
    '2026-02-24 07:30:00',
    '127.0.0.1',
    'Edge'
),
(
    '40000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGIN_FAIL'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-23 21:14:00',
    '192.168.1.10',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000005',
    NULL,
    'LOGIN_FAIL'::access_event_type,
    'intruso@correo.com',
    '2026-02-23 21:30:00',
    '192.168.1.77',
    'Unknown'
),
(
    '40000000-0000-0000-0000-000000000006',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGIN_SUCCESS'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-24 08:00:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000007',
    (SELECT id FROM "user" WHERE email = 'demo.user1@finanzas.pe'),
    'LOGOUT'::access_event_type,
    'demo.user1@finanzas.pe',
    '2026-02-24 08:45:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000008',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'PASSWORD_RESET_REQUEST'::access_event_type,
    'demo.user2@finanzas.pe',
    '2026-02-22 16:00:00',
    '127.0.0.1',
    'Safari'
),
(
    '40000000-0000-0000-0000-000000000009',
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'PASSWORD_RESET_SUCCESS'::access_event_type,
    'demo.user2@finanzas.pe',
    '2026-02-22 16:10:00',
    '127.0.0.1',
    'Safari'
),
(
    '40000000-0000-0000-0000-000000000010',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'EMAIL_VERIFY_SENT'::access_event_type,
    'demo.user3@finanzas.pe',
    '2026-02-14 16:30:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000011',
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'EMAIL_VERIFY_SUCCESS'::access_event_type,
    'demo.user3@finanzas.pe',
    '2026-02-14 16:33:00',
    '127.0.0.1',
    'Chrome'
),
(
    '40000000-0000-0000-0000-000000000012',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'LOGOUT'::access_event_type,
    'demo.admin@finanzas.pe',
    '2026-02-24 09:00:00',
    '127.0.0.1',
    'Edge'
)
ON CONFLICT (id) DO UPDATE
SET
    user_id = EXCLUDED.user_id,
    event_type = EXCLUDED.event_type,
    attempt_email = EXCLUDED.attempt_email,
    created_at = EXCLUDED.created_at,
    ip_address = EXCLUDED.ip_address,
    web_agent = EXCLUDED.web_agent;

INSERT INTO admin_audit_log (
    id,
    actor_user_id,
    target_user_id,
    target_snapshot_id,
    target_snapshot_name,
    target_snapshot_email,
    action,
    details,
    created_at,
    ip_address,
    web_agent
)
VALUES
(
    '50000000-0000-0000-0000-000000000001',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    'Admin Demo',
    'demo.admin@finanzas.pe',
    'USER_CREATE',
    'role=admin',
    '2026-02-20 10:30:00',
    '127.0.0.1',
    'Chrome'
),
(
    '50000000-0000-0000-0000-000000000002',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user2@finanzas.pe'),
    'Mariel User Demo',
    'demo.user2@finanzas.pe',
    'USER_UPDATE',
    'fields=full_name,email',
    '2026-02-21 11:10:00',
    '127.0.0.1',
    'Chrome'
),
(
    '50000000-0000-0000-0000-000000000003',
    (SELECT id FROM "user" WHERE email = 'demo.admin@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    (SELECT id FROM "user" WHERE email = 'demo.user3@finanzas.pe'),
    'Jeff User Demo',
    'demo.user3@finanzas.pe',
    'USER_UPDATE',
    'fields=password',
    '2026-02-22 15:25:00',
    '127.0.0.1',
    'Edge'
),
(
    '50000000-0000-0000-0000-000000000004',
    (SELECT id FROM "user" WHERE email = 'demo.owner@finanzas.pe'),
    NULL,
    '10000000-0000-0000-0000-000000000099',
    'Deleted User Demo',
    'deleted.user@finanzas.pe',
    'USER_DELETE',
    'deleted_role=user',
    '2026-02-23 12:00:00',
    '127.0.0.1',
    'Chrome'
)
ON CONFLICT (id) DO UPDATE
SET
    actor_user_id = EXCLUDED.actor_user_id,
    target_user_id = EXCLUDED.target_user_id,
    target_snapshot_id = EXCLUDED.target_snapshot_id,
    target_snapshot_name = EXCLUDED.target_snapshot_name,
    target_snapshot_email = EXCLUDED.target_snapshot_email,
    action = EXCLUDED.action,
    details = EXCLUDED.details,
    created_at = EXCLUDED.created_at,
    ip_address = EXCLUDED.ip_address,
    web_agent = EXCLUDED.web_agent;

COMMIT;
