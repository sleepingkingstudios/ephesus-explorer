# Explorer Development Notes

## Commands

GoDirection - e.g. 'go north'
GoToRoom - e.g. 'go to Bird Town'

## Entities

Explorer::Entities::Interactible

Explorer::Entities::InteractibleRoom
  - belongs_to :interactible
  - belongs_to :room

Explorer::Entities::Room
  - belongs_to :default_layer, class: RoomLayer, inverse_of: nil
  - has_many :layers, class: RoomLayer, inverse_of: Room
  - has_many :interactibles, through: interactible_rooms

Explorer::Entities::RoomLayer
  - modifies properties
  - adds exits
  - adds interactibles
