import React, { Component } from 'react';
import { inject, observer } from 'mobx-react';

import { STORES } from '../../../constants';
import StoreStore from '../../../stores/store/StoreStore';

type InjectedProps = {
  [STORES.STORE_STORE]?: StoreStore;
  store_seq: string;
};

@inject(STORES.STORE_STORE)
@observer
class StoreInfo extends Component<InjectedProps> {
  constructor(props: any) {
    super(props);
    const store_seq = this.props.store_seq;
    this.state = {
      store_seq,
    };
  }

  render() {
    return (
      <>
        <div>스토어 정보</div>
      </>
    );
  }
}

export default StoreInfo;
