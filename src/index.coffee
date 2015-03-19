shallowCopy = (o) ->
  c = {}
  for own k, v of o
    c[k] = v
  c

onX = (type) -> (propName, f) ->
  onT    = "on#{type}"
  offT   = "off#{type}"
  boundF = null

  subscribe = (props, component) ->
    boundF = f.bind(component)
    props[propName][onT](boundF)

  unsubscribe = (props) ->
    props[propName][offT](boundF)

  {
    componentDidMount: ->
      subscribe(@props, this)

    componentWillUnmount: ->
      unsubscribe(@props)

    componentWillReceiveProps: (nextProps) ->
      if @props[propName] != nextProps[propName]
        unsubscribe(@props)
        subscribe(nextProps, this)
  }

# :: (String, a -> b) -> React.Mixin
#
# Given the name of a prop of type (Kefir e a) and a function, returns a
# component mixin that will subscribe the function to the stream when the
# component mounts and unsubscribes when it unmounts.
#
# The function is called in the context of the component, i.e. `this` will be
# the component.
#
# The mixin also handles props changing, cleaning up subscriptions and
# resubscribing as necessary.
#
onValue = onX('Value')

# :: (String, e -> b) -> React.Mixin
#
# Given the name of a prop of type (Kefir e a) and a function, returns a
# component mixin that will subscribe the function to the stream's errors
# when the component mounts and unsubscribes when it unmounts.
#
# The function is called in the context of the component, i.e. `this` will be
# the component.
#
# The mixin also handles props changing, cleaning up subscriptions and
# resubscribing as necessary.
#
onError = onX('Error')

# :: (String, (s, a) -> s) -> React.Mixin
#
# Given the name of a prop of type (Kefir e a) and a stateful computation that
# computes the next state of the component in terms of the current state and an
# `a`, returns a Component mixin that will update the state of the component
# whenever an `a` is emitted from the stream.
#
connectUpdate = (propName, f) ->
  updateState = (a) -> @setState(f(@state, a))
  onValue(propName, updateState)

# :: String -> React.Mixin
#
# Given the name of a stream-valued prop, sets the component's state to the
# value emitted by the stream.
#
connectSet = (propName) ->
  connectUpdate(propName, (_, x) -> x)

# :: (String, String) -> React.Mixin
#
# Given the name of a stream-valued prop and the name of a state property,
# sets the state property to the value of the stream every time it emits a
# value.
#
connectKey = (propName, stateKey) ->
  connectUpdate(propName, (s, x) ->
    s1 = shallowCopy(s)
    s1[stateKey] = x
    s1)

module.exports = {onValue, onError, connectUpdate, connectSet, connectKey}

