ExtendedLogger = require '../../lib/helpers/extended-logger'

describe 'ExtendedLogger', ->

  beforeEach ->
    @log = new ExtendedLogger
      additionalFields:
        project_key: 'foo'
        another_field: 'bar'

  it 'should initialize with default options', ->
    log = new ExtendedLogger()

    expect(log.additionalFields).toEqual {}
    expect(log.bunyanLogger).toBeDefined()

  it 'should initialize with custom options', ->
    expect(@log.additionalFields).toEqual
      project_key: 'foo'
      another_field: 'bar'
    expect(@log.bunyanLogger).toBeDefined()

  describe ':: wrapper', ->

    it 'should log with extended object and message', ->
      spyOn(@log.bunyanLogger, 'info')
      @log.info {id: 123}, 'Hello'
      expect(@log.bunyanLogger.info).toHaveBeenCalledWith {id: 123, project_key: 'foo', another_field: 'bar'}, 'Hello'

    it 'should log with additional fields and message', ->
      spyOn(@log.bunyanLogger, 'info')
      @log.info 'Hello'
      expect(@log.bunyanLogger.info).toHaveBeenCalledWith {project_key: 'foo', another_field: 'bar'}, 'Hello'

    it 'should log with extended object and no message', ->
      spyOn(@log.bunyanLogger, 'info')
      @log.info {id: 123}
      expect(@log.bunyanLogger.info).toHaveBeenCalledWith {id: 123, project_key: 'foo', another_field: 'bar'}, undefined

  describe ':: withField', ->

    it 'should chain field for extended object', ->
      spyOn(@log.bunyanLogger, 'info')
      @log.withField(token: 'qwerty').info {id: 123}, 'Hello'
      expect(@log.bunyanLogger.info).toHaveBeenCalledWith {id: 123, project_key: 'foo', another_field: 'bar', token: 'qwerty'}, 'Hello'
