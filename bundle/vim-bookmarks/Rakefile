require 'rake/packagetask'
require 'octokit'

GIT_REPO = "MattesGroeger/vim-bookmarks"
VIM_SCRIPT_URL = "http://www.vim.org/scripts/add_script_version.php?script_id=4893"
LABELS = ["feature", "enhancement", "bug"]

task :default => [:release]
task :ci => [:dump, :test]

desc "Dump version numbers"
task :dump do
  sh 'vim --version'
end

desc "Run tests"
task :test do
  sh "bundle exec vim-flavor test"
end

desc "Create release archive"
task :release do
  version = request_user_input("Which version do you want to release (0.1.0)?")
  file_path = create_zip(version)
  if request_user_input("Create git release now? (y/n)") == 'y'
    upload_release(version, file_path)
  end
end

desc "See the changelog for a specific version"
task :changelog do
  version = request_user_input("For which version (0.1.0)?")
  show_changelog(version)
end

def create_zip(version)
  file_path = "release/vim-bookmarks-#{version}.zip"
  `mkdir -p release`
  `zip -r #{file_path} . -i "doc/*" -i "plugin/*" -i "autoload/*" -i LICENSE`
  file_path
end

def upload_release(version, asset_path)
  asset_name = asset_path.split("/")[-1]

  # login to github
  @client = Octokit::Client.new(netrc: true)
  @client.login

  # get all milestones
  milestones = @client.milestones(GIT_REPO)
  milestone = milestones.select { |m|
    m.title == version
  }.first
  return puts "Unable to find milestone for version #{version}. Aborted!" if !milestone

  # abort if there are still open issues
  return puts "Found #{milestone.open_issues} open issues for milestone #{version}. Close them first!" if milestone.open_issues > 0

  # get change log via issues
  issues = @client.issues(GIT_REPO, milestone: milestone.number, state: :closed)
  changes = build_changelog(issues)

  # get contributor sentence
  thanks = contributor_sentence_since_last_release()

  # show change log, get it confirmed by user (y/n)
  changelog = changes.join
  changelog << "\n#{thanks}" unless thanks.nil?
  puts "> Changelog:\n#{changelog}\n\n"
  return puts "Aborted!" if request_user_input("Do you want to create release #{version} with the above changelog? (y/n)", "n").downcase != "y"

  # create release
  release = @client.create_release(GIT_REPO, version, name: "vim-bookmarks-#{version}", body: changelog)
  puts "> Created release #{release.name} (id: #{release.id})\n\n"

  # if release exists already:
  # releases = @client.releases(GIT_REPO)
  # release = releases.first

  # upload asset
  release_url = "https://api.github.com/repos/#{GIT_REPO}/releases/#{release.id}"
  asset = @client.upload_asset(release_url, asset_path, content_type: 'application/zip', name: asset_name)
  puts "> Uploaded asset #{asset.name} (id: #{asset.id})\n\n"

  # close milestone
  @client.update_milestone(GIT_REPO, milestone.number, state: :closed)
  puts "> Closed milestone #{version}. Done!"

  if request_user_input("Update script on vim.org now? (y/n)", "n").downcase == "y"
    `open "#{VIM_SCRIPT_URL}"`
  end
end

def show_changelog(version)
  # login to github
  @client = Octokit::Client.new(netrc: true)
  @client.login

  # get all milestones
  milestones = @client.milestones(GIT_REPO) + @client.milestones(GIT_REPO, state: :closed)
  milestone = milestones.select { |m|
    m.title == version
  }.first
  return puts "Unable to find milestone for version #{version}. Aborted!" if !milestone

  # get change log via issues
  issues = @client.issues(GIT_REPO, milestone: milestone.number, state: :closed)

  # show change log
  puts "\nChangelog:\n\n#{build_changelog(issues).join}\n"
end

def build_changelog(issues)
  issues.map { |i|
    label = (LABELS & i.labels.map { |l| l.name }).first
    label_txt = label == "bug" ? "bugfix" : label
    line = " * [#{label_txt}] #{i.title} ##{i.number}\n" if label
    {label: label, issue: i.number, line: line}
  }.select { |f|
    f[:label] != nil
  }.sort { |a, b|
    [LABELS.find_index(a[:label]),b[:issue]] <=> [LABELS.find_index(b[:label]),a[:issue]]
  }.map { |e|
    e[:line]
  }
end

def contributor_sentence_since_last_release()
  releases = @client.releases(GIT_REPO)
  since = releases.size > 0 ? releases.first.created_at : nil
  contributors = contributors(since)
  contributor_sentence(contributors)
end

def contributors(from = nil, to = nil)

  # Get all by default
  from = Time.new(1).utc.iso8601 if from.nil?
  to = Time.now.utc.iso8601 if to.nil?

  # Get all commits since last release
  commits = @client.commits(GIT_REPO, sha: :master, since: from, until: to)

  # Get all collaborators
  collaborators = @client.collaborators(GIT_REPO).map { |c|
    c.login
  }

  # Find all authors that are not site_admin
  contributor_map = commits.inject({}) { |hash, commit|
    if commit.author.nil?
      user = "[#{commit.commit.author.name}](mailto:#{commit.commit.author.email})"
      hash[user] = 1
    else
      login = commit.author.login
      user = "@#{login}"
      if collaborators.index(login).nil? # exclude repo maintainer
        change_count = @client.commit(GIT_REPO, commit.sha).stats.total
        hash[user] = hash[user].nil? ? change_count : hash[user] + change_count
      end
    end
    hash
  }

  # Sort them by number of changes (importance)
  contributor_map.keys.sort { |a, b|
    contributor_map[b] <=> contributor_map[a]
  }.map { |c|
    "#{c}"
  }
end

def contributor_sentence(contributors)
  if contributors.size == 0
    return nil
  elsif contributors.size == 1
    authors = "#{contributors.first} for the contribution"
  else
    last = contributors.pop
    authors = "#{contributors.join(', ')} and #{last} who contributed"
  end
  "Thanks #{authors} to this release!"
end

def request_user_input(message, fallback = "")
  STDOUT.puts message
  input = STDIN.gets.strip.to_s
  if input.empty?
    if fallback.empty?
      request_user_input(message) # try again
    else
      fallback.to_s
    end
  else
    input.to_s
  end
end
