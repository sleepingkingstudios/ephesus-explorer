# Explorer Development Notes

Explorer::AbstractController
- ::action - defines action
- #action?
- #actions

Explorer::Controller
- property :current_session # instance of Explorer::Session
- action :go { GoCommand.new(current_session) }

Explorer::Session
- property :current_room

## Commands

Explorer::Commands::GoCommand
- constructor takes Explorer::Session instance
- process takes direction: keyword
- finds matching exit in current_room#exits
- if no matching exit, errors
- if exit#destination invalid, errors
- changes current room to destination

## Entities

Explorer::Entities::Room
- attribute :description
- has_many :exits, class: RoomExit, inverse_of: :room

Explorer::Entities::RoomExit
- attribute :direction # North, south, left, up, &c.
- belongs_to :room
- belongs_to :destination, inverse_of: nil

### Future Steps

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
