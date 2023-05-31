# Tinger

Tinger is a command-line tool that pings all links from a file, checks if they are alive, and logs the live links in a new file. It supports HTTP, HTTPS, and UDP links.

## Installation

To run Tinger from source, download it and run `dart run tinger <arguments>` in the root directory.

You can also download the executable from the [releases](https://github.com/zbejas/tinger/releases/) page and run it directly from the command line.

_Note: The EXE file is not signed, so you might get a warning from Windows Defender._
_Another note: Tinger has no Windows libraries, so it should run on Linux and macOS as well with the EXE build._

## Usage

`./tinger.exe -p <path> -o <output> [-t <timeout>] [-r <retries>] [-h]`
(or `dart run tinger <arguments>` if running from source)

---

| Option            | Description                   | Default Value       |
| ----------------- | ----------------------------- | ------------------- |
| `-p`, `--path`    | Path to file containing links | `list.txt`          |
| `-o`, `--output`  | Path to output file           | `working_links.txt` |
| `-t`, `--timeout` | Timeout in seconds            | `3`                 |
| `-r`, `--retries` | Number of retries             | `3`                 |
| `-h`, `--help`    | Show help message and exit    | N/A                 |

---

## Examples

- `./tinger.exe -p trackers.txt -o output.txt -t 1 -r 0`

  - Pings all links from `trackers.txt` with a timeout of 1 second and no retries, and logs the live links in `output.txt`.

Example of a `trackers.txt` file:

```
https://tracker1.com/announce
https://tracker2.com/announce
udp://tracker3.com/announce
```

or

```
https://tracker1.com/announce

https://tracker2.com/announce

udp://tracker3.com/announce
```

Example of an `output.txt` file:

```
https://tracker1.com/announce

udp://tracker3.com/announce
```

_lets just say that tracker2 is down_
