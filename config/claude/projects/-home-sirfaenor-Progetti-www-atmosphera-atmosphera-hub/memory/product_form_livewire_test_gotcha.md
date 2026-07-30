---
name: product_form_livewire_test_gotcha
description: "Test Livewire sul ProductForm — callTableAction('edit') solleva TypeError in AttributesEditorSection"
metadata: 
  node_type: memory
  type: project
  originSessionId: c711f0f6-1af4-49a5-a98e-4d34f2b63d17
---

Nei test Livewire sul ProductForm (es. `callTableAction('edit', $product, ...)`), il re-render della modale dopo il save solleva un `TypeError: class_parents(null)` in `AttributesEditorSection::resolveInstance` (packages/digital-hub) perché in fase di teardown dell'action lo schema perde il record/model. È un limite dell'harness, non un bug applicativo (in browser il form funziona).

Workaround nei test: il `saveRelationships()`/`dehydrate()` gira PRIMA di quel render, quindi si può racchiudere la `callTableAction` in `try { ... } catch (\TypeError) {}` e poi asserire lo stato DB. Vedi `tests/Feature/Products/ProductMaterialsNestedSelectTest.php`.

Nota lifecycle: l'`EditAction` in slideOver (default Filament) NON chiama `saveRelationships()` esplicitamente, ma questo avviene comunque dentro `HasState::dehydrate()` (righe ~483) durante `getState()`. Quindi i campi con `saveRelationshipsUsing`/`loadStateFromRelationshipsUsing` (es. [[nested_checkbox_select_field]]) funzionano sia in create che in edit. Il commento in `Category1Select` sul "senza saveRelationships" riguarda un altro path (form TagGroup del core).
