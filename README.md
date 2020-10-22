# Reflekt

<p align="center">
  <img src="./assets/Logo.svg" raw=true width="200" style="margin-left: auto; margin-right: auto;"/>
</p>
<p align="center">
  <a href="https://www.mozilla.org/MPL/2.0/" alt="MPLv2 License">
    <img src="https://img.shields.io/badge/license-MPLv2-blue.svg" />
  </a>
  <a href="https://rubygems.org/gems/reflekt">
    <img src="https://badge.fury.io/rb/reflekt.svg" alt="Gem Version" />
  </a>
</p>

*Reflective testing.*

Traditional testing is fine but it's not perfect. Tests often check for a golden path that works, when errors actually happen when the code or user does something unexpected. And with automated testing humans still have to write the tests.

**Reflekt** writes the tests for you, and tests in the negative for situations that you wouldn't have noticed. It works out of the box with no extra coding required. Because Reflekt tests your objects as they are used in the normal flow of the application, you get real world test results.

## Usage  

Add `prepend Reflekt` inside a class:
```ruby
class ExampleClass
  prepend Reflekt
```  

Use the application as usual and test results will start showing up in the `reflections` folder:

<p align="center">
  <img src="./assets/Screenshot.jpg" raw=true style="margin-left: auto; margin-right: auto;"/>
</p>

## Installation

In Gemfile add:
```ruby
gem "reflekt"
```  

In terminal run:
```
bundle install
```

## Configuration

You can configure Reflekt to skip "no undo" methods like deletion and sending email:

```ruby
class ExampleClass
  reflekt_skip :method_name
```

### Displaying test data

Use `reflekt_skip` on methods that do the final render to the UI to avoid a visual mess of duplicated elements.
Ensure that there is a dedicated method that renders output, so that Reflekt can track changes in output.

**Do:**
```ruby

```

**Don't do:**
```ruby

```

### Saving test data

If you don't want test data to save to the database then use [dependency injection](https://www.reddit.com/r/programming/comments/iz3rks/if_youre_not_practicing_within_the_scope_of_a/g6i1ex3/) to connect to a dummy database, like you would with unit testing. To check when Reflekt is enabled use the `@reflekt_enabled` boolean property on an object, or use `reflekt_skip` on the method that saves to the database.

## How it works

When a method is called in the usual flow of an application, Reflekt runs multiple simulations with different values on that method to see if it can break things, before handing back control to the method to perform its usual task.

<p align="center">
  <img src="./assets/Flowchart.svg" raw=true width="600" style="margin-left: auto; margin-right: auto;"/>
</p>

## Comparison

Conceptual differences between testing methodologies:

|                   | Traditional testing       | Generative testing           | Reflective testing        |
--------------------|---------------------------|------------------------------|---------------------------|
| **Automation**    | ❌ Defined manually       | ❌ Defined semi-automatically | ✅ Defined automatically  |
| **Granularity**   | ✅ Tests PASS or FAIL     | ✅ Tests PASS or FAIL         | ✅ Tests PASS or FAIL     |
| **Replication**   | ❌ Tests run externally   | ❌ Tests run externally       | ✅ Tests run internally   |
| **Feedback loop** | ❌ Tests run periodically | ❌ Tests run periodically     | ✅ Tests run in real time |

Consider this logic:  
1. Tests often check that things work (in the positive)  
2. Errors happen when things break (in the negative)  
3. Tests should check more often for the negative  
4. This can be automated

## FAQ

**Q.** Can I use it alongside test driven development too?  
**A.** Yes!
