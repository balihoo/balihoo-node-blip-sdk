pkg = require '../package.json'
error = require './error'
MissingCredentialsError = error.MissingCredentialsError
BadResponseError = error.BadResponseError
HttpClient = require './HttpClient'

module.exports =
  class BlipSdk
    constructor: (options) ->
      if not options?.apiKey? or not options?.secretKey?
        throw new error.MissingCredentialsError()

      host = options.host or 'blip.balihoo-cloud.com'
      port = options.port or 443
      ssl = if options.ssl? then options.ssl else true
      concurrency = options.concurrency or 10
      
      @httpClient = new HttpClient
        host: host
        port: port
        ssl: ssl
        concurrency: concurrency
        apiKey: options.apiKey
        secretKey: options.secretKey

    getBrands: ->
      @httpClient.get '/brand'
      .then (response) ->
        if response.statusCode is 200
          response.body
        else
          throw new BadResponseError 'getBrands', response.body
