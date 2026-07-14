{ ... }:
{
  # Increase inotify limits to allow more files to be watched
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 512;
  };
}
