class GitHub::Fetcher
  attr_accessor :client, :repo

  def initialize(token = nil, repo)
    token ||= ENV['GITHUB_API_TOKEN']
    @client = Octokit::Client.new(access_token: token)
    @repo ||= ENV['REPO']
  end

  def fetch(commit_hashes = [])
    [].tap do |array|
      commit_hashes.each do |sha|
        array << get_pull_request(sha)
      end
    end
  end

  def get_pull_request(sha)
    client.legacy_search_issues(repo, sha).first
  end
end