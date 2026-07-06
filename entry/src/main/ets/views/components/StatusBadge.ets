@ComponentV2
export struct StatusBadge {
  @Param @Require isActive: boolean = false;

  build() {
    Text(this.isActive ? 'LIVE' : 'IDLE')
      .fontSize(10)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.isActive ? '#4ADE80' : '#555555')
      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
      .borderRadius(10)
      .backgroundColor(this.isActive ? '#1A3A1A' : '#1E1E1E')
  }
}