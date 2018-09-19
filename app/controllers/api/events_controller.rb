module Api
  class EventsController < ApplicationController
    def index
      @note_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "tag")
      @test_drive_events = current_user.dealership.events.includes(tag: :shape).where(event_type: "test_drive")

      render json: {
                      tag_events: @note_events.map{|e| EventSerializer.new(e).serialized_json},
                      test_drive_events: @test_drive_events.map{|e| EventSerializer.new(e).serialized_json}
                    }
    end
  end
end