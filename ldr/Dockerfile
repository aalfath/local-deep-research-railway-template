# Local Deep Research for Railway: the official image, pinned by version and
# digest, plus a small start script (Railway PORT, proxy headers, first admin).
FROM localdeepresearch/local-deep-research:2.0.1@sha256:867e4ebf8baff9b5a759d2ae154359fe0ecb19b5e8231409feea4e781d5733ae

COPY railway-start.sh /usr/local/bin/railway-start.sh
COPY railway-run-as-user.sh /usr/local/bin/railway-run-as-user.sh
COPY create_admin.py /usr/local/bin/railway_create_admin.py
USER root
RUN chmod 0755 /usr/local/bin/railway-start.sh /usr/local/bin/railway-run-as-user.sh \
    && chmod 0644 /usr/local/bin/railway_create_admin.py

ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["ldr-web"]
