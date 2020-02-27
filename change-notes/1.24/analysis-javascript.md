# Improvements to JavaScript analysis

## General improvements

* TypeScript 3.8 is now supported.

* Alert suppression can now be done with single-line block comments (`/* ... */`) as well as line comments (`// ...`).

* Imports with the `.js` extension can now be resolved to a TypeScript file,
  when the import refers to a file generated by TypeScript.

* Imports that rely on path-mappings from a `tsconfig.json` file can now be resolved.

* Export declarations of the form `export * as ns from "x"` are now analyzed more precisely.

* The analysis of sanitizer guards has improved, leading to fewer false-positive results from the security queries.

* The call graph construction has been improved, leading to more results from the security queries:
  - Calls can now be resolved to indirectly-defined class members in more cases.
  - Calls through partial invocations such as `.bind` can now be resolved in more cases.

* Support for the following frameworks and libraries has been improved:
  - [Electron](https://electronjs.org/)
  - [Handlebars](https://www.npmjs.com/package/handlebars)
  - [Koa](https://www.npmjs.com/package/koa)
  - [Node.js](https://nodejs.org/)
  - [Socket.IO](https://socket.io/)
  - [WebSocket](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API)
  - [chrome-remote-interface](https://www.npmjs.com/package/chrome-remote-interface)
  - [for-in](https://www.npmjs.com/package/for-in)
  - [for-own](https://www.npmjs.com/package/for-own)
  - [http2](https://nodejs.org/api/http2.html)
  - [lazy-cache](https://www.npmjs.com/package/lazy-cache)
  - [react](https://www.npmjs.com/package/react)
  - [send](https://www.npmjs.com/package/send)
  - [typeahead.js](https://www.npmjs.com/package/typeahead.js)
  - [ws](https://github.com/websockets/ws)

## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cross-site scripting through exception (`js/xss-through-exception`) | security, external/cwe/cwe-079, external/cwe/cwe-116              | Highlights potential XSS vulnerabilities where an exception is written to the DOM. Results are not shown on LGTM by default. |
| Regular expression always matches (`js/regex/always-matches`) | correctness, regular-expressions | Highlights regular expression checks that trivially succeed by matching an empty substring. Results are shown on LGTM by default. |
| Missing await (`js/missing-await`) | correctness | Highlights expressions that operate directly on a promise object in a nonsensical way, instead of awaiting its result. Results are shown on LGTM by default. |
| Polynomial regular expression used on uncontrolled data (`js/polynomial-redos`) | security, external/cwe/cwe-730, external/cwe/cwe-400 | Highlights expensive regular expressions that may be used on malicious input. Results are shown on LGTM by default. | 
| Prototype pollution in utility function (`js/prototype-pollution-utility`) | security, external/cwe/cwe-400, external/cwe/cwe-471 | Highlights recursive copying operations that are susceptible to prototype pollution. Results are shown on LGTM by default. |
| Unsafe jQuery plugin (`js/unsafe-jquery-plugin`) | Highlights potential XSS vulnerabilities in unsafely designed jQuery plugins. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | More results | More results involving `process.env` and indirect calls to logging methods are recognized. |
| Duplicate parameter names (`js/duplicate-parameter-name`) | Fewer results | This query now recognizes additional parameters that reasonably can have duplicated names. |
| Incomplete string escaping or encoding (`js/incomplete-sanitization`) | Fewer false positive results | This query now recognizes additional cases where a single replacement is likely to be intentional. |
| Unbound event handler receiver (`js/unbound-event-handler-receiver`) | Fewer false positive results | This query now recognizes additional ways event handler receivers can be bound. | 
| Expression has no effect (`js/useless-expression`) | Fewer false positive results | The query now recognizes block-level flow type annotations and ignores the first statement of a try block. |
| Use of call stack introspection in strict mode (`js/strict-mode-call-stack-introspection`) | Fewer false positive results | The query no longer flags expression statements. |
| Missing CSRF middleware (`js/missing-token-validation`) | Fewer false positive results | The query reports fewer duplicates and only flags handlers that explicitly access cookie data. |
| Uncontrolled data used in path expression (`js/path-injection`) | More results | This query now recognizes additional ways dangerous paths can be constructed. |
| Uncontrolled command line (`js/command-line-injection`) | More results | This query now recognizes additional ways of constructing arguments to `cmd.exe` and `/bin/sh`. |

## Changes to libraries

* The predicates `RegExpTerm.getSuccessor` and `RegExpTerm.getPredecessor` have been changed to reflect textual, not operational, matching order. This only makes a difference in lookbehind assertions, which are operationally matched backwards. Previously, `getSuccessor` would mimick this, so in an assertion `(?<=ab)` the term `b` would be considered the predecessor, not the successor, of `a`. Textually, however, `a` is still matched before `b`, and this is the order we now follow.
* An extensible model of the `EventEmitter` pattern has been implemented.