class McafeeVirusScanLinux < Hydra::Works::VirusScanner

  # @param file [String]
  # @param uvscan_path [String]
  def initialize(file, uvscan_path: '/usr/local/bin/uvscan')
    @file = file
    @uvscan_path = uvscan_path
  end

  def infected?
    system("which #{@uvscan_path}") ? mcafee_scanner : null_scanner
  end

  def mcafee_scanner
    scan_command = "sudo #{@uvscan_path} --delete --verbose #{file}"
    system(scan_command)
    file_exists = Dir.glob(file)
    return false unless file_exists.empty?
    warning "A virus was found in #{file}"
    true
  end
end
