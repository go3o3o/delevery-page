import React, { Component } from 'react';
import { RouteComponentProps } from 'react-router';
import { Link } from 'react-router-dom';

import { Layout, Input, Button, Row, Col, List } from 'antd';
import { AimOutlined, SearchOutlined } from '@ant-design/icons';

import { PAGE_PATHS, STORES } from '../../constants';
import AuthStore from '../../stores/auth/AuthStore';
import { AddressList } from './AddressList';
import { CodeNode } from 'source-list-map';

// TO DO LIST
// 1. DB에 음식점 정보 넣기
// 2. Login 페이지
// 3. Sign up 페이지

class Header extends Component {
  constructor(props) {
    super(props);
    this.state = {
      visible: false,
      location: false,
      longitude: 0,
      latitude: 0,
      address: '',
      addressList: [],
    };

    this.getLocation = this.getLocation.bind(this);
    this.setAddress = this.setAddress.bind(this);
  }

  componentWillMount() {
    this.getLocation();
  }

  setAddress = e => {
    this.setState({ address: e.target.value });
  };

  // 키워드로 주소 찾기
  getAddress = () => {
    // console.log(this.state['address']);
    if (this.state['address'].length > 0) {
      fetch(`https://dapi.kakao.com/v2/local/search/keyword.json?query=${this.state['address']}`, {
        method: 'GET',
        headers: {
          Authorization: `KakaoAK ${process.env.KAKAO_KEY}`,
        },
      })
        .then(res => res.json())
        .then(json => {
          if (json.documents.length > 0) {
            let addressList = [];
            json.documents.map(address => {
              // console.log(address);
              addressList.push(address);
            });
            this.setState({ addressList });
            this.setState({ visible: true });
          }
        })
        .catch(err => console.log(err));
    }
  };

  // 경도와 위도로 주소 찾기
  getLocationAddress = () => {
    // console.log(this.state['longitude'], this.state['latitude']);
    fetch(
      `https://dapi.kakao.com/v2/local/geo/coord2address.json?x=${this.state['longitude']}&y=${this.state['latitude']}`,
      {
        method: 'GET',
        headers: {
          Authorization: `KakaoAK ${process.env.KAKAO_KEY}`,
        },
      },
    )
      .then(res => res.json())
      .then(json => {
        // console.log(Object.keys(json));
        if (json.documents.length > 0) {
          let address = json.documents[0].address.address_name;
          this.setState({ address });
        }
      })
      .catch(err => console.log(err));
  };

  getLocation = () => {
    if (navigator.geolocation) {
      // GPS 를 지원하면
      navigator.geolocation.getCurrentPosition(
        position => {
          let longitude = position.coords.longitude;
          let latitude = position.coords.latitude;
          this.setState({ longitude, latitude });
          this.setState({ location: true });
          this.getLocationAddress();
        },
        err => {
          console.log(err);
        },
        {
          enableHighAccuracy: false,
          maximumAge: 0,
          timeout: Infinity,
        },
      );
    } else {
      alert('현재 위치를 가져올 수 없습니다.');
    }
  };

  setAddressListVisible = () => {
    if (!this.state['visible']) {
      document.addEventListener('click', this.handleOutsideClick, !this.state['visible']);
    }

    this.setState({ visible: !this.state['visible'] });
  };

  handleOutsideClick = e => {
    this.setState({ visible: false });
  };

  render() {
    return (
      <>
        <Layout
          style={{
            textAlign: 'center',
            padding: '40px 100px 40px 120px',
            backgroundColor: '#5FBEBB',
          }}
        >
          <Row justify="space-around" align="middle">
            <Col span={12} style={{ textAlign: 'left' }}>
              <Link to={'/'} style={{ marginRight: 30 }}></Link>
              <Button
                onClick={this.getLocation}
                style={{
                  display: 'inline',
                  backgroundColor: '#FFF',
                  borderColor: 'white',
                  height: 39,
                  width: 39,
                  marginRight: 5,
                  verticalAlign: 'bottom',
                }}
                icon={
                  <AimOutlined
                    style={{ verticalAlign: 'middle', color: '#5FBEBB', fontSize: 20 }}
                  />
                }
              ></Button>
              <Input
                placeholder="건물명, 도로명, 지번으로 검색하세요."
                suffix={
                  <a onClick={this.getAddress}>
                    <SearchOutlined
                      style={{
                        verticalAlign: 'middle',
                        color: '#5FBEBB',
                        fontSize: 20,
                      }}
                    />
                  </a>
                }
                style={{ width: 330, height: 40 }}
                value={this.state['address']}
                onChange={this.setAddress}
                onClick={this.setAddressListVisible}
              />
              {this.state['visible'] && (
                <List
                  dataSource={this.state['addressList']}
                  renderItem={(item: any) => (
                    <List.Item key={item.id}>
                      <List.Item.Meta title={item.place_name} description={item.address_name} />
                    </List.Item>
                  )}
                />
              )}
            </Col>
            <Col span={12}>
              <Link to={`${PAGE_PATHS.SIGNIN}`}>
                <Button
                  style={{
                    backgroundColor: '#5FBEBB',
                    borderColor: 'white',
                    height: 40,
                    verticalAlign: 'middle',
                  }}
                >
                  <span style={{ color: 'white', fontSize: 20 }}>로그인 | 회원가입</span>
                </Button>
              </Link>
            </Col>
          </Row>
        </Layout>
      </>
    );
  }
}

export default Header;
