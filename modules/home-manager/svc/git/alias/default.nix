{
  g = "git";
  ga = "git add";
  gaa = "git add .";
  gcb = "git checkout $(git branch | fzf | tr -d '[:space:]')";
  gco = "git checkout";
  gnb = "git checkout -b";
  gr = "git restore";
  gcl = "git clone";
  gp = "git pull";
  gf = "git fetch";
  gps = "git push";
  gc = "git commit";
  gcm = "git commit -m";
  gd = "git diff";
  gds = "git diff --staged";
  gb = "git branch";
  gm = "git merge";
  grb = "git rebase";
  glg = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
  gl = "git log --graph --pretty=oneline --abbrev-commit";
  gshw = "git show";
  gpa = "git pull --all";
  gpsf = "git push --force-with-lease";
  gs = "git status";
  cgcb = "git checkout -b";
  gbd = "git branch -d $(git branch | fzf)";
  gbdel = "git branch -D $(git branch | fzf)";
}
