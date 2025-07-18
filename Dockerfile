FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev expect \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/trustedsec/social-engineer-toolkit /opt/setoolkit
WORKDIR /opt/setoolkit

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    python setup.py install

# Create expect script to accept terms
RUN echo '#!/usr/bin/expect\nspawn setoolkit\nsleep 1\nsend "y\\r"\ninteract' > /accept_terms.exp && \
    chmod +x /accept_terms.exp

EXPOSE 10000

CMD ["/accept_terms.exp"]
