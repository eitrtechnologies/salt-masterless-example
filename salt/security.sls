
manage_etc_shadow:
  file.managed:
    - name: /etc/shadow
    - replace: False
    - user: root
    - group: shadow
    - mode: "0640"
