import { ActivityIndicatorBase, busyProperty, colorProperty, Color } from "./activity-indicator-common";

export * from "./activity-indicator-common";

import { ios } from "../../utils/utils";

const majorVersion = ios.MajorVersion;

export class ActivityIndicator extends ActivityIndicatorBase {
    nativeViewProtected: UIActivityIndicatorView;

    private _activityIndicatorViewStyle = majorVersion <= 12 ? UIActivityIndicatorViewStyle.Gray : UIActivityIndicatorViewStyle.Medium;

    createNativeView() {
        const viewStyle = this._activityIndicatorViewStyle;
        const view = UIActivityIndicatorView.alloc().initWithActivityIndicatorStyle(viewStyle);
        view.hidesWhenStopped = true;

        return view;
    }

    get ios(): UIActivityIndicatorView {
        return this.nativeViewProtected;
    }

    [busyProperty.getDefault](): boolean {
        if ((<any>this.nativeViewProtected).isAnimating) {
            return (<any>this.nativeViewProtected).isAnimating();
        }
        else {
            return this.nativeViewProtected.animating;
        }
    }
    [busyProperty.setNative](value: boolean) {
        let nativeView = this.nativeViewProtected;
        if (value) {
            nativeView.startAnimating();
        } else {
            nativeView.stopAnimating();
        }

        if (nativeView.hidesWhenStopped) {
            this.requestLayout();
        }
    }

    [colorProperty.getDefault](): UIColor {
        return this.nativeViewProtected.color;
    }
    [colorProperty.setNative](value: UIColor | Color) {
        this.nativeViewProtected.color = value instanceof Color ? value.ios : value;
    }
}
