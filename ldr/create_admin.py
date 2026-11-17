"""Create the first Local Deep Research account from ADMIN_USERNAME and
ADMIN_PASSWORD, once. Does nothing when the account already exists, so
changing the variables later never touches existing data. The password is
also the key of the user's encrypted database: change it in the app
(Settings), not here."""

import os
import sys
from pathlib import Path

username = os.environ.get("ADMIN_USERNAME", "").strip()
password = os.environ.get("ADMIN_PASSWORD", "")

if not username or not password:
    print("railway: ADMIN_USERNAME or ADMIN_PASSWORD not set, no admin created")
    sys.exit(0)

data_dir = Path(os.environ.get("LDR_DATA_DIR", "/data"))
(data_dir / "encrypted_databases").mkdir(parents=True, exist_ok=True)

from local_deep_research.database.auth_db import (  # noqa: E402
    auth_db_session,
    init_auth_database,
)
from local_deep_research.database.encrypted_db import db_manager  # noqa: E402
from local_deep_research.database.models.auth import User  # noqa: E402
from local_deep_research.security.password_validator import (  # noqa: E402
    PasswordValidator,
)

init_auth_database()
if db_manager.user_exists(username):
    print(f"railway: account '{username}' already exists, nothing to do")
    sys.exit(0)

errors = PasswordValidator.validate_strength(password)
if errors:
    print("railway: ADMIN_PASSWORD rejected: " + "; ".join(errors))
    sys.exit(1)

print(f"railway: creating account '{username}' (first boot)")
with auth_db_session() as session:
    user = User(username=username)
    session.add(user)
    session.commit()
    user_id = user.id

try:
    db_manager.create_user_database(username, password)
except Exception:
    with auth_db_session() as session:
        orphan = session.query(User).filter_by(id=user_id).first()
        if orphan is not None:
            session.delete(orphan)
            session.commit()
    raise

try:
    from local_deep_research.database.library_init import (
        initialize_library_for_user,
    )

    initialize_library_for_user(username, password)
except Exception as err:  # the app retries library setup on login
    print(f"railway: library init skipped ({type(err).__name__})")

print(f"railway: account '{username}' created")
