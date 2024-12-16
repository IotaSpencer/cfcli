## --output formats documentation

#### Table

The default output format, when no format flag is specified, this will be used.

Table uses ASCII tables, to display responses in a human readable format.

#### YAML

YAML is a data serialization format that can be used to store and transmit data.

```sh
$ cfcli zones dns-records add example.com A 1.2.3.4 --format yaml
```
```yaml
---
action: add
name: example.com
type: A
content: 1.2.3.4
ttl: 300
proxied: true
---
```

#### Pipe

Pipe allows you to pipe the results of a cfcli command to another command or the terminal. Its written in a way that is easy to read and parse (hopefully).

```sh
$ cfcli ips list --format pipe
```
```text
IPv4
1.1.1.1 2.2.2.2 3.3.3.3

IPv6
1:1:1:1:1:1:1:1 2:2:2:2:2:2:2:2 3:3:3:3:3:3:3:3
``` 