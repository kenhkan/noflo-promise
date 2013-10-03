# Promises/A+ for NoFlo <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-promise.png?branch=master)](http://travis-ci.org/kenhkan/noflo-promise) [![Dependency Status](https://david-dm.org/kenhkan/noflo-promise.png)](https://david-dm.org/kenhkan/noflo-promise) [![NPM version](https://badge.fury.io/js/noflo-promise.png)](http://badge.fury.io/js/noflo-promise) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-promise.png)](http://waffle.io/kenhkan/noflo-promise)

Provide [Promises/A+](http://promises-aplus.github.io/promises-spec/)
_handling_ in NoFlo by wrapping around the [NPM module
promise](https://npmjs.org/package/promise). It doesn't make sense to create
promises in NoFlo because NoFlo itself is the framework to manage your
program's flow. Therefore, this package simply provides ways to manipulate
_existing_ promises used in parts of your program that are _not_ within NoFlo.


## Installation

`npm install --save noflo-promise`

## Usage

* [promise/From](#from)
* [promise/Then](#then)

Listed in-ports in **bold** are required and out-ports in **bold** always produce IPs.


### From

Wrapper around `Promise#from(1)` to convert a non-promise into a promise.

#### In-Ports

* **IN**: The value to convert

#### Out-Ports

* **OUT**: A promise


### Then

Accept a promise, set it to forward the passed value to _SUCCESS_ upon
fulfillment of the promise or to _FAILURE_ upon rejection, then forward the
promise onto _OUT_ if it's attached.

Each passed parameter is forwarded as an IP. For instance, a promise that would
look in procedural JS:

    promise.then(function(a, b, c) {

... would be translated as three IPs of the values of a, b, and c.

#### In-Ports

* **IN**: A promise

#### Out-Ports

* OUT: A promise
* SUCCESS: Forwarded the passed value on fulfillment
* FAILURE: Forwarded the passed value on rejection
