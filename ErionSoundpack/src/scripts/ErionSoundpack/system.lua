erion = erion or {}
erion.packages = erion.packages or {}
erion.packages["@PKGNAME@"] = "@PKGNAME@"

if erion.system then
  erion.system:register("@PKGNAME@")
end

