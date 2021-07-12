import React from "react";
import { PageHeader } from "antd";

export default function Header() {
  return (
    <a href="/" /*target="_blank" rel="noopener noreferrer"*/>
      <PageHeader
        title="🦈 Finney Vendor"
        subTitle="Token vendor for FIN (Finney), 1/1000th of an ETH"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}
