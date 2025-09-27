import { NgModule } from '@angular/core';
import { OpenProjectPluginContext } from 'core-app/features/plugins/plugin-context';
import { PaperlessTabComponent } from './paperless-tab/paperless-tab.component';

export function initializePaperlessPlugin() {
  window.OpenProject.getPluginContext()
    .then((pluginContext: OpenProjectPluginContext) => {
      // Register work package tab
      pluginContext.hooks.workPackageTabs((tabs: any[]) => {
        return tabs.concat({
          id: 'paperless',
          name: 'Paperless Documents',
          component: PaperlessTabComponent,
          displayable: (workPackage: any) => {
            return workPackage.project.modules.includes('storages');
          }
        });
      });
    });
}

@NgModule({
  declarations: [
    PaperlessTabComponent
  ],
  providers: [],
  exports: [
    PaperlessTabComponent
  ]
})
export class PluginModule {
  constructor() {
    initializePaperlessPlugin();
  }
}