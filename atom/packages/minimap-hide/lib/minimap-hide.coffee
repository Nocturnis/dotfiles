{TextEditor} = require 'atom'

module.exports =
  active: false
  activeEditor: null

  isActive: -> @active

  activate: ->

  consumeMinimapServiceV1: (@minimap) ->
    @minimap.registerPlugin 'minimap-hide', this

  deactivate: ->
    @minimap.unregisterPlugin 'minimap-hide'
    @minimap = null

  activatePlugin: ->
    return if @active
    @active = true

    for editor in atom.workspace.getTextEditors()
      @hide(editor)

    @changePaneSubscription = atom.workspace.observeActivePaneItem((item) =>
      @hide(@activeEditor) if @activeEditor?
      @activeEditor = null
      return unless item instanceof TextEditor
      @show(item)
      @activeEditor = item
    )

  deactivatePlugin: ->
    return unless @active

    @active = false
    @changePaneSubscription.dispose()

  show: (editor) ->
    minimapElement = atom.views.getView(@minimap.minimapForEditor(editor))
    minimapElement?.attach()

  hide: (editor) ->
    minimapElement = atom.views.getView(@minimap.minimapForEditor(editor))
    # MinimapElement::detachedCallback is not called in the case of display:none
    if minimapElement?.offsetParent isnt null
      minimapElement?.detach()
