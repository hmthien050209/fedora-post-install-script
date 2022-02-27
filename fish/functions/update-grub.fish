function update-grub --wraps='sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg' --description 'alias update-grub=sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
  sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg $argv; 
end
