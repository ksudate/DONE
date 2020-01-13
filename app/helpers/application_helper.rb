module ApplicationHelper
  def javascript_path
    path = "#{controller_path}/#{controller_path}.js"
    return 'default.js' unless javascript_file_exist?(path)

    path
  end

  def javascript_file_exist?(path)
    manifest = File.open('public/packs/manifest.json') do |file|
      JSON.load(file)
    end
    manifest.key?(path)
  end
end
