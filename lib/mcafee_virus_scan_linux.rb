class McafeeVirusScanLinux < Hydra::Works::VirusScanner

  # @param file [String]
  # @param uvscan_path [String]
  def initialize(file, uvscan_path: "/usr/local/bin/uvscan")
    super
    @uvscan_path = uvscan_path
  end

  def infected?
    scan_command = "#{@uvscan_path} -c -v #{file}"
    scan_result = `#{scan_command}`
    return false if scan_result == 0
    warning "A virus was found in #{file}: #{scan_result}"
    true
  end
end