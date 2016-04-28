class PivotalTracker::Fetcher
  attr_accessor :client, :project, :endpoint
  def initialize(token = nil, project_id = nil)
    token ||= ENV['PIVOTAL_API_TOKEN']
    project_id ||= ENV['PROJECT_ID']
    @client = TrackerApi::Client.new(token: token)
    @project = @client.project(project_id)
    @endpoint = 'https://www.pivotaltracker.com/services/' +
                  "v5/projects/#{@project[:id]}/releases/#{ENV['RELEASE_ID']}/stories"
  end

  def fetch
    [].tap do |array|
      release_stories.each do |story|
        array << story_data(story)
      end
    end
  end


  private

  def release_stories
    response = RestClient.get(endpoint, 'X-TrackerToken' => ENV['PIVOTAL_API_TOKEN'])
    JSON.parse(response)
  end

  def story_data(story)
    story.slice(:id, :name, :url)
  end
end

