import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap/dist/js/bootstrap.min";

import React, { Component } from "react";
import { Route, Routes } from "react-router-dom";

import CompareSeries from "./series/CompareSeries";
import CrimeChart from "./crime/CrimeChart";
import EachLocation from "./location/EachLocation";
import EventChart from "./event/EventChart";
import Location from "./location/LocationTwitter";
import LocationChart from "./location/LocationChart";
import MainPage from "./MainPage";
import TootsSeries from "./series/TootsSeries";
import TweetsSeries from "./series/TweetsSeries";

class Content extends Component {
  render() {
    return (
      <>
        <div className="content">
          <Routes>
            <Route path="/" element={<MainPage />} />
            <Route path="/location" element={<Location />} />
            <Route path="/locationChart" element={<LocationChart />} />
            <Route path="/event" element={<EventChart />} />
            <Route path="/eachLocation" element={<EachLocation />} />
            <Route path="/crimeChart" element={<CrimeChart />} />
            <Route path="/tootsSeries" element={<TootsSeries />} />
            <Route path="/tweetsSeries" element={<TweetsSeries />} />
            <Route path="/compareSeries" element={<CompareSeries />} />
          </Routes>
        </div>
      </>
    );
  }
}

export default Content;
