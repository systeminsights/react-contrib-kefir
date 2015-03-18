K = require 'kefir'
React = require 'react/addons'
TestUtils = React.addons.TestUtils

describe "kefir mixin", ->
  describe "onValue", ->
    it 'should subscribe the function to the observable when component mounts'
    it 'should invoke the function in the context of the component on every value'
    it 'should unsubscribe the function from the observable when component unmounts'

  describe "onError", ->
    it 'should subscribe the function to the observable when component mounts'
    it 'should invoke the function in the context of the component on every error'
    it 'should unsubscribe the function from the observable when component unmounts'

  describe "connectUpdate", ->
    it 'should invoke the update function with the current state and set the component state to the result'

  describe "connectSet", ->
    it 'should set the component state to the value emitted by the observable'

  describe "connectKey", ->
    it 'should set the specified state property to the value emitted by the observable'

