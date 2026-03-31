const teamMembers = [
  {
    name: "Sarah Johnson",
    role: "Head Librarian",
    image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop"
  },
  {
    name: "Michael Chen",
    role: "Digital Resources Manager",
    image: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop"
  },
  {
    name: "Emily Rodriguez",
    role: "Community Outreach",
    image: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop"
  },
  {
    name: "David Thompson",
    role: "Collections Curator",
    image: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop"
  }
];

const timeline = [
  { year: "1985", event: "Library Founded", description: "Started with 1,000 books" },
  { year: "2000", event: "Digital Expansion", description: "Introduced online catalog" },
  { year: "2015", event: "Mobile App Launch", description: "Access library on the go" },
  { year: "2026", event: "AI Integration", description: "Smart recommendations system" }
];

const teamGrid = document.getElementById("teamGrid");
const timelineList = document.getElementById("timelineList");

teamMembers.forEach(function(member) {
  const card = document.createElement("div");
  card.className = "team-card";

  card.innerHTML = `
    <img src="${member.image}" alt="${member.name}">
    <div class="team-content">
      <h3>${member.name}</h3>
      <p>${member.role}</p>
    </div>
  `;

  teamGrid.appendChild(card);
});

timeline.forEach(function(item) {
  const timelineItem = document.createElement("div");
  timelineItem.className = "timeline-item";

  timelineItem.innerHTML = `
    <div class="timeline-year">${item.year}</div>
    <div class="timeline-card">
      <h3>${item.event}</h3>
      <p>${item.description}</p>
    </div>
  `;

  timelineList.appendChild(timelineItem);
});