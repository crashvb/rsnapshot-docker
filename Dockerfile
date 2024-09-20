FROM crashvb/cron:202404131826@sha256:663a13bc37ef2db8d336eabe3b88734d65ac3a5674c539eb116ec18ba4642cc6
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:663a13bc37ef2db8d336eabe3b88734d65ac3a5674c539eb116ec18ba4642cc6" \
	org.opencontainers.image.base.name="crashvb/supervisord:202404131826" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing rsnapshot." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/rsnapshot-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/rsnapshot" \
	org.opencontainers.image.url="https://github.com/crashvb/rsnapshot-docker"

# Install packages, download files ...
RUN docker-apt openssh-client rsnapshot

# Configure: rsnapshot
ENV \
	RSNAPSHOT_CONFIG=/etc/rsnapshot \
	RSNAPSHOT_DATA=/var/lib/rsnapshot
COPY rsnapshot-* /usr/local/bin/
COPY cron.rsnapshot /etc/cron.hourly/rsnapshot
COPY logrotate.rsnapshot /etc/logrorate.d/rsnapshot
RUN install --directory --group=root --mode=0755 --owner=root /root/.ssh/ && \
	sed --expression="/UserKnownHostsFile/cUserKnownHostsFile ${RSNAPSHOT_CONFIG}/known_hosts" --in-place /etc/ssh/ssh_config && \
	ln --force --symbolic "${RSNAPSHOT_CONFIG}/known_hosts" /root/.ssh/known_hosts && \
	ln --force --symbolic "${RSNAPSHOT_CONFIG}/ssh_config" /root/.ssh/config && \
	install --directory --group=root --mode=0755 --owner=root "${RSNAPSHOT_CONFIG}" && \
	mv /etc/rsnapshot.conf "${RSNAPSHOT_CONFIG}/rsnapshot.conf.dist" && \
	cp --preserve /etc/cron.hourly/rsnapshot /etc/cron.daily/ && \
	cp --preserve /etc/cron.hourly/rsnapshot /etc/cron.weekly/ && \
	cp --preserve /etc/cron.hourly/rsnapshot /etc/cron.monthly/

# Configure: profile
RUN echo "export RSNAPSHOT_CONFIG=\"${RSNAPSHOT_CONFIG}\"" > /etc/profile.d/rsnapshot.sh && \
	chmod 0755 /etc/profile.d/rsnapshot.sh

# Configure: entrypoint
COPY entrypoint.rsnapshot /etc/entrypoint.d/rsnapshot

VOLUME "${RSNAPSHOT_CONFIG}" "${RSNAPSHOT_DATA}"
