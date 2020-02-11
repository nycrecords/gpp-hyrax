class McafeeVirusScanLinux < Hydra::Works::VirusScanner

  # @param file [String]
  # @param uvscan_path [String]
  def initialize(file, uvscan_path: '/usr/local/bin/uvscan')
    @file = file
    @uvscan_path = uvscan_path
  end

  def infected?
    scan_command = "#{@uvscan_path} --delete -v #{file.path}"
    scan_result = `#{scan_command}`
    file_exists = Dir.glob(file.path)
    return false unless file_exists.empty?
    warning "A virus was found in #{file.path}"
    true
  end
end