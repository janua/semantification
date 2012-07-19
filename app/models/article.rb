class Article
  attr_reader :id, :title, :author, :body, :published_date, :main_image, :main_image_caption

  include BackedByYaml
  set_mock_path "mock_data/articles"

  def initialize(id, data)
    @id = id
    @type = data[:type]
    @title = data[:title]
    @author = data[:author]
    @body = data[:body]
    @is_live = data[:is_live]
    @published_date = data[:published_date]
    @main_image = data[:main_image]
    @main_image_caption = data[:main_image_caption]

    @main_event_id = data[:main_event]
  end

  def main_event
    @main_event ||= @main_event_id && Event.get_by_id(@main_event_id)
  end

  def secondary_events
    []
  end

  def main_story
    main_event.main_story
  end

  def body_text
    if body.is_a?(Array)
      body.map do |live_block|
        "<div class=\"block\" id=\"block-#{live_block[:id]}\">" +
          "<time>"+Time.parse(live_block[:date]).to_s + "</time>: " +
          live_block[:text] +
          "</div>"
      end.join
    else
      body
    end
  end

  # NOTE: liveblog specific
  def is_live?
    @is_live
  end

  def extract_main_actors(limit)
    # TODO: parse?
    body_text.scan(/<span class="gu-ref.*" data-ref-id="(.*?)">.*?<\/span>/)
  end

  def ==(other)
    self.class == other.class && self.id == other.id
  end
end
