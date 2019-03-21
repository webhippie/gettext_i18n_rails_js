<template>
  <base-table-actions v-if="canInteract"
                      class="spec-banner-actions">

    <div v-if="canCopy"
         @click="handleCopy"
         class="dropdown-item">{{ __("Hello\nBuddy") }}</div>

    <div v-if="canArchive"
         @click="handleArchive"
         class="dropdown-item">{{ archivePlaceholder }}</div>
  </base-table-actions>
</template>


<script>
function pepito() {
  var string = "this" + __('json') + 'should be translated';
  alert(n__('item', 'items', 3));
}
</script>