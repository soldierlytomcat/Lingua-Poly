#! /bin/false
#
# Lingua-Poly   Language Disassembling Library
# Copyright (C) 2018-2019 Guido Flohr <guido.flohr@Lingua::Poly::API.com>
#			   All rights reserved
#
# This library is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What the Fuck You Want
# to Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

package Lingua::Poly::API::Users::Service::Database::Statements;

use strict;


sub new {
	bless {
		INSERT_SESSION => <<EOF,
INSERT INTO sessions(sid, fingerprint, identity_provider_id, nonce)
  VALUES(?, ?, (SELECT id FROM identity_providers WHERE name = ?), ?)
EOF
		DELETE_SESSION => <<EOF,
DELETE FROM sessions
  WHERE sid = ?
EOF
		DELETE_SESSION_STALE => <<EOF,
DELETE FROM sessions
  WHERE EXTRACT(EPOCH FROM(NOW() - last_seen)) > ?
EOF
		SELECT_SESSION => <<EOF,
SELECT s.user_id, p.name, s.token, s.nonce
  FROM sessions s, identity_providers p
 WHERE sid = ?
   AND s.identity_provider_id = p.id
   AND fingerprint = ?
EOF
		UPDATE_SESSION => <<EOF,
UPDATE sessions
   SET last_seen = NOW()
 WHERE sid = ?
EOF
		UPDATE_SESSION_SID => <<EOF,
UPDATE sessions
   SET sid = ?, user_id = ?, last_seen = NOW(),
       identity_provider_id
           = (SELECT id FROM identity_providers WHERE name = ?),
       token = ?,
	   nonce = ?
 WHERE sid = ?
EOF

		DELETE_TOKEN_STALE => <<EOF,
DELETE FROM tokens
  WHERE EXTRACT(EPOCH FROM(NOW() - created)) > ?
EOF
		INSERT_TOKEN => <<EOF,
INSERT INTO tokens(token, purpose, user_id)
  VALUES(?, ?, (SELECT id FROM users WHERE email = ?))
EOF
		UPDATE_TOKEN => <<EOF,
UPDATE tokens SET created = NOW()
  WHERE tokens.purpose = ?
    AND tokens.user_id = (SELECT id FROM users WHERE email = ?)
EOF
		DELETE_TOKEN => <<EOF,
DELETE FROM tokens WHERE token = ?
EOF
		SELECT_USER_BY_TOKEN => <<EOF,
SELECT u.id, u.username, u.email, u.external_id, u.password, u.confirmed FROM tokens t, users u
  WHERE t.purpose = ?
    AND t.token = ?
	AND t.user_id = u.id
EOF
		SELECT_TOKEN_BY_PURPOSE => <<EOF,
SELECT t.token FROM tokens t, users u
  WHERE t.purpose = ?
    AND u.email = ?
    AND t.user_id = u.id
	AND NOT u.confirmed
EOF
		INSERT_USER => <<EOF,
INSERT INTO users(email, password, confirmed, external_id)
  VALUES(?, ?, ?, ?)
EOF
		UPDATE_USER => <<EOF,
UPDATE users
   SET email = ?,
       external_id = ?,
       username = ?,
       homepage = ?,
	   description = ?
 WHERE id = ?
EOF

		DELETE_USER => <<EOF,
DELETE FROM users where id = ?
EOF

		DELETE_USER_STALE => <<EOF,
DELETE FROM users u
  USING tokens t
  WHERE NOT u.confirmed
    AND u.id = t.user_id
	AND EXTRACT(EPOCH FROM(NOW() - t.created)) > ?
EOF

		SELECT_USER_BY_ID => <<EOF,
SELECT username, email, password, confirmed, homepage, description
  FROM users WHERE id = ?
EOF

		SELECT_USER_BY_USERNAME => <<EOF,
SELECT id, username, email, external_id,
       password, confirmed, homepage, description
  FROM users WHERE username = ?
EOF

		SELECT_USER_BY_EMAIL => <<EOF,
SELECT id, username, email, external_id,
       password, confirmed, homepage, description
  FROM users WHERE email = ?
EOF

		SELECT_USER_BY_EXTERNAL_ID => <<EOF,
SELECT id, username, email, external_id,
       password, confirmed, homepage, description
  FROM users WHERE external_id = ?
EOF

		UPDATE_USER_ACTIVATE => <<EOF,
UPDATE users
   SET confirmed = 't'
 WHERE id = ?
EOF

		SELECT_CONFIG => <<EOF,
SELECT value, expires
  FROM configs
 WHERE name = ?
   AND expires < NOW()
EOF

		UPSERT_CONFIG => <<EOF,
INSERT INTO configs(name, value, expires)
  VALUES(?, ?, ?)
  ON CONFLICT(name) DO UPDATE
    SET value = EXCLUDED.value, expires = EXCLUDED.value
EOF
	}, shift;
};

1;

