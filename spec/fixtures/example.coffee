pepito = ->
  string = "this" + __('json') + 'should be translated'
  alert(n__('item', 'items', 3))

example_template( __('Hello {yourname}'), { yourname: 'bob' })

object =
 one: N__('new-trans')
 two: s__('namespaced', 'trans')

"#{ __("Hello\nBuddy") }"

"""
  #{ __("Multi-line") }
"""

$("<option>").text(__("Your Boards")).attr("value", "User|#{Gigabase.user_id}")