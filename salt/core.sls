
manage_etc_hosts:
  file.managed:
    - name: /etc/hosts
    - replace: False
    - user: root
    - group: root
    - mode: "0644"
