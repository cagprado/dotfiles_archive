defaultpen(1+solid+black);

// SAVE/RESTORE #############################################################
// Save (and restore) currentpicture in order to temporarily draw in a clean
// picture.
private void ManagePicture(bool save)
{
  static picture pic;
  if (save) {
    pic = currentpicture;
    currentpicture = new picture;
  }
  else
    currentpicture = pic;
}
void Save() { ManagePicture(true); }
void Restore() { ManagePicture(false); }

// PAGES ####################################################################
// Save currentpicture as a new page. Finish all pages with DrawPages()
private void ManagePages(bool push)
{
  static picture[] pages;
  if (push) {
    pages.push(currentpicture);
    currentpicture = new picture;
  }
  else {
    for (picture page : pages) {
      add(page.fit(),0);
      newpage();
    }
    pages.delete();
  }
}
void PushPage() { ManagePages(true); }
void DrawPages() { ManagePages(false); }
